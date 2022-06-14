package com.bilab.lunsenluandroid;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;


import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.bilab.lunsenluandroid.Adapter.RecycleViewDoctorAuth;
import com.bilab.lunsenluandroid.model.DAData;
import com.wang.avi.AVLoadingIndicatorView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.lang.reflect.Array;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import javax.net.ssl.SSLSocketFactory;


public class DoctorAuthActivity extends AppCompatActivity {


    ImageView previous;
    Button button_insert;
    TextView doctor_auth_empty;
    RecyclerView recyclerView;
    ScrollView recycler_view;

    AVLoadingIndicatorView loading;
    private static final String TAG = "MainActivity";
    public  static RecycleViewDoctorAuth adapter;

    private ArrayList<String> mNames = new ArrayList<>();
    private ArrayList<String> mDetails = new ArrayList<>();
    private ArrayList<String> mImageUrls = new ArrayList<>();

    private static RequestQueue objpostqueue;
    private static StringRequest postRequest,postRequest_remove,postRequest_checkid;
    private final static String strposturl_get = "https://lunsenlu.cf/doctor_auth/get_doctor_auth";//"https://140.124.183.197:8000/doctor_auth/get_doctor_auth";
    private final static String strposturl_remove = "https://lunsenlu.cf/doctor_auth/delete_doctor_auth";//"https://140.124.183.197:8000/doctor_auth/delete_doctor_auth";
    private final static String strposturl_checkid = "https://lunsenlu.cf/account/check_id";//"https://140.124.183.197:8000/account/check_id";
    String request_result,target_email,target_password,request_id = "";
    private static int target_position;
    List<DAData> postData;

    String email;

    Intent intent;

    String[][] strArray;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.doctor_auth);
        getSupportActionBar().hide();
        Log.d(TAG, "onCreate: started.");

        previous =  (ImageView) findViewById(R.id.doctor_auth_previous);
        button_insert = (Button) findViewById(R.id.doctor_auth_insert);
        doctor_auth_empty = (TextView) findViewById(R.id.doctor_auth_empty);
        recycler_view = findViewById(R.id.recycler_view);
        recyclerView = findViewById(R.id.doctor_recycler_view);
        loading = findViewById(R.id.doctor_auth_loading);
        loading.smoothToShow();

        intent = this.getIntent();
        email = (intent != null ) ? intent.getStringExtra("email") : "";

        //objpostqueue = Volley.newRequestQueue(this);
        //HTTPSTrustManager.allowAllSSL();

        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        initial();
        objpostqueue.add(postRequest_checkid);

        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        button_insert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(request_id.equals("")){
                    showdialog();
                }
                else {
                    Intent intent = new Intent();
                    Bundle bundle = new Bundle();
                    intent.setClass(DoctorAuthActivity.this, DoctorInsertActivity.class);
                    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    bundle.putString("id",request_id);
                    intent.putExtras(bundle);
                    startActivity(intent);
                    finish();
                }

            }
        });

    }

    public void initial(){
        String masterKeyAlias = null;
        try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount", masterKeyAlias, DoctorAuthActivity.this,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            target_email = sharedPreferences.getString("email", "");
            target_password = sharedPreferences.getString("password", "");
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        /*SharedPreferences sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
        target_email = sh.getString("email","");
        target_password = sh.getString("password","");
        Log.v("bbb",target_password);*/
        postRequest_checkid = new StringRequest(Request.Method.POST, strposturl_checkid,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONObject jsonObject=new JSONObject(response);
                            request_result = jsonObject.getString("result");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        if(request_result.equals("fail")) {
                            Log.v("error account checkid ", "account checkid  error");
                            loading.setVisibility(View.GONE);
                            doctor_auth_empty.setVisibility(View.VISIBLE);
                        }
                        else{
                            Log.v("success account checkid", "account checkid  success");
                            request_id = request_result;
                            objpostqueue.add(postRequest);
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //如果發生錯誤，就是回傳VolleyError，可以顯示是什麼錯誤。
                Log.v("error",error.getMessage());
            }
        }) {
            @Override
            protected HashMap<String,String> getParams()
                    throws AuthFailureError {

                //跟GET模式不同的是，後續要加入傳入參數的函式。
                HashMap<String,String> hashMap = new HashMap<String,String>();

                hashMap.put("email",target_email);
                hashMap.put("password",target_password);
                return hashMap;
            }
        };
        postRequest = new StringRequest(Request.Method.POST, strposturl_get,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONObject jsonObject=new JSONObject(response);
                            request_result = jsonObject.getString("result");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        if(request_result.equals("fail")) {
                            Log.v("error account main", "account main錯誤");
                            recycler_view.setVisibility(View.GONE);
                            loading.setVisibility(View.GONE);
                            doctor_auth_empty.setVisibility(View.VISIBLE);
                        }
                        else{
                            try {
                                doctor_auth_empty.setVisibility(View.GONE);
                                loading.setVisibility(View.GONE);
                                recycler_view.setVisibility(View.VISIBLE);
                                JSONObject jsonObject=new JSONObject(response);
                                Log.v("length json",String.valueOf(jsonObject.length()));
                                postData = new ArrayList<>();
                                for(int i = 1; i < jsonObject.length();i++){
                                    JSONArray jsonarray = jsonObject.getJSONArray(String.valueOf(i));
                                    Log.v("jsonaaa"+i,String.valueOf(jsonarray));

                                    DAData data = new DAData();
                                    data.setId(i);
                                    data.setHospital(jsonarray.get(0).toString());
                                    data.setDepartment(jsonarray.get(1).toString());
                                    data.setName(jsonarray.get(2).toString());
                                    //data.setImage(jsonarray.get(3) == null || jsonarray.get(3).toString().equals("") || jsonarray.get(3).toString().equals("null") ? "https://cdn3.iconfinder.com/data/icons/shipping-and-delivery-2-1/512/54-512.png" : jsonarray.get(3).toString());
                                    postData.add(data);
                                }
                                initRecyclerView();
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //如果發生錯誤，就是回傳VolleyError，可以顯示是什麼錯誤。
                Log.v("error",error.getMessage());
            }
        }) {
            @Override
            protected HashMap<String,String> getParams()
                    throws AuthFailureError {

                //跟GET模式不同的是，後續要加入傳入參數的函式。
                HashMap<String,String> hashMap = new HashMap<String,String>();
                Log.v("aaa",request_id);
                hashMap.put("email",target_email);
                hashMap.put("user_id",request_id);

                return hashMap;
            }
        };
        postRequest_remove = new StringRequest(Request.Method.POST, strposturl_remove,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONObject jsonObject=new JSONObject(response);
                            request_result = jsonObject.getString("result");
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        if(request_result.equals("fail"))
                            Log.v("error account remove", "account remove error");
                        else{
                            Log.v("success account remove", "account remove success");
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //如果發生錯誤，就是回傳VolleyError，可以顯示是什麼錯誤。
                Log.v("error",error.getMessage());
            }
        }) {
            @Override
            protected HashMap<String,String> getParams()
                    throws AuthFailureError {

                //跟GET模式不同的是，後續要加入傳入參數的函式。
                HashMap<String,String> hashMap = new HashMap<String,String>();

                hashMap.put("email",target_email);
                hashMap.put("user_id",request_id);
                hashMap.put("position",String.valueOf(target_position));
                return hashMap;
            }
        };

    }

    private void initRecyclerView(){
        Log.d(TAG, "initRecyclerView: init recyclerview.");
        //recyclerView = findViewById(R.id.recyclerv_view);
        //RecyclerViewAdapter adapter = new RecyclerViewAdapter(this, mNames, mImageUrls,mDetails);
        adapter = new RecycleViewDoctorAuth(this, postData);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(new DefaultItemAnimator());
        recyclerView.setAdapter(adapter);
    }

    public static void notifyAdapter(int position){
        target_position = position+1;
        objpostqueue.add(postRequest_remove);
        adapter.notifyDataSetChanged();
    }

    public void showdialog(){
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("您在個人資料身分證字號欄位為空");
        dialog.setMessage("因醫生授權需要使用您的身分證字號做查詢的動作，故請您按下確定跳轉到個人帳戶頁面輸入您的身分證字號，請放心我們並不會用在除醫生授權其他任何地方");
        dialog.setNegativeButton("取消",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface arg0, int arg1) {
                // TODO Auto-generated method stub
            }

        });
        dialog.setPositiveButton("確定",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface arg0, int arg1) {
                // TODO Auto-generated method stub
                Intent intent = new Intent();
                intent.setClass(DoctorAuthActivity.this, AccountPasswordActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intent.putExtra("activity", "doctor_auth");
                startActivity(intent);
            }

        });
        dialog.show();
    }
}
