package com.bilab.lunsenluandroid;


import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.HashMap;

import androidx.appcompat.app.AppCompatActivity;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import javax.net.ssl.SSLSocketFactory;

public class AccountMainActivity extends AppCompatActivity {

    TextView edit_button,finish_button,name_text,email_text,password_text,phone_text,id_text;
    EditText name_edit,email_edit,password_edit,phone_edit,id_edit;
    ImageView previous_button,cancel_button;

    private RequestQueue objpostqueue;
    private StringRequest postRequest,postRequest_edit;
    private final static String strposturl = "https://lunsenlu.cf/account/get_personal_data";//"https://biolab1621.cf/account/get_personal_data";//"https://140.124.183.197:8000/account/get_personal_data";
    private final static String strposturl_2 = "https://lunsenlu.cf/account/edit_personal_data";//"https://140.124.183.197:8000/account/edit_personal_data";
    String request_result,target_email,target_password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.account_main);
        getSupportActionBar().hide();
        Intent intent = this.getIntent();
        String activity = intent.getStringExtra("activity");
        previous_button = (ImageView)findViewById(R.id.account_main_previous);
        cancel_button = (ImageView)findViewById(R.id.account_main_cancel);
        edit_button =  (TextView) findViewById(R.id.account_main_edit);
        finish_button =  (TextView) findViewById(R.id.account_main_finish);
        name_text =  (TextView) findViewById(R.id.account_main_name_text);
        email_text =  (TextView) findViewById(R.id.account_main_email_text);
        password_text =  (TextView) findViewById(R.id.account_main_password_text);
        phone_text =  (TextView) findViewById(R.id.account_main_phone_text);
        id_text =  (TextView) findViewById(R.id.account_main_id_text);
        name_edit =  (EditText) findViewById(R.id.account_main_name_edit);
        email_edit =  (EditText) findViewById(R.id.account_main_email_edit);
        password_edit =  (EditText) findViewById(R.id.account_main_password_edit);
        phone_edit =  (EditText) findViewById(R.id.account_main_phone_edit);
        id_edit =  (EditText) findViewById(R.id.account_main_id_edit);

        //objpostqueue = Volley.newRequestQueue(this);
        //HTTPSTrustManager.allowAllSSL();

        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        initial();
        objpostqueue.add(postRequest);
        initial();
        edit_setting();
        objpostqueue.add(postRequest);



        previous_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(activity.equals("health_pass")){
                    Intent intent = new Intent();
                    intent.setClass(AccountMainActivity.this, HealthPassActivity.class);
                    startActivity(intent);
                }
                else if(activity.equals("doctor_auth")){
                    Intent intent = new Intent();
                    intent.setClass(AccountMainActivity.this, DoctorAuthActivity.class);
                    startActivity(intent);
                }
                finish();
            }
        });
        cancel_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                return_back();
                objpostqueue.add(postRequest);
            }
        });
        edit_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                previous_button.setVisibility(View.GONE);
                cancel_button.setVisibility(View.VISIBLE);
                edit_button.setVisibility(View.GONE);
                finish_button.setVisibility(View.VISIBLE);
                name_text.setVisibility(View.GONE);
                name_edit.setVisibility(View.VISIBLE);
                password_text.setVisibility(View.GONE);
                password_edit.setVisibility(View.VISIBLE);
                phone_text.setVisibility(View.GONE);
                phone_edit.setVisibility(View.VISIBLE);
                id_text.setVisibility(View.GONE);
                id_edit.setVisibility(View.VISIBLE);
                objpostqueue.add(postRequest);
            }
        });
        finish_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(checkCardId(id_edit.getText().toString())) {
                    objpostqueue.add(postRequest_edit);
                    return_back();
                }
                else{
                    showdialog();
                }
            }
        });
    }

    public void return_back(){
        previous_button.setVisibility(View.VISIBLE);
        cancel_button.setVisibility(View.GONE);
        edit_button.setVisibility(View.VISIBLE);
        finish_button.setVisibility(View.GONE);
        name_text.setVisibility(View.VISIBLE);
        name_edit.setVisibility(View.GONE);
        password_text.setVisibility(View.VISIBLE);
        password_edit.setVisibility(View.GONE);
        phone_text.setVisibility(View.VISIBLE);
        phone_edit.setVisibility(View.GONE);
        id_text.setVisibility(View.VISIBLE);
        id_edit.setVisibility(View.GONE);
    }
    public void initial(){
        String masterKeyAlias = null;
        try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount", masterKeyAlias, AccountMainActivity.this,
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
        target_password = sh.getString("password","");*/
        postRequest = new StringRequest(Request.Method.POST, strposturl,
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
                            Log.v("error account main","account main錯誤");
                        else{
                            try {
                                JSONObject jsonObject=new JSONObject(response);
                                name_text.setText(jsonObject.getString("name"));
                                email_text.setText(jsonObject.getString("email"));
                                password_text.setText(jsonObject.getString("password"));
                                phone_text.setText(jsonObject.getString("phone"));
                                id_text.setText((jsonObject.getString("user_id").equals("null") ? "" :jsonObject.getString("user_id")));
                                name_edit.setText(jsonObject.getString("name"));
                                email_edit.setText(jsonObject.getString("email"));
                                password_edit.setText(jsonObject.getString("password"));
                                phone_edit.setText(jsonObject.getString("phone"));
                                id_edit.setText((jsonObject.getString("user_id").equals("null") ? "" :jsonObject.getString("user_id")));
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

                hashMap.put("email",target_email);
                hashMap.put("password",target_password);
                return hashMap;
            }
        };
    }

    public void edit_setting(){
        postRequest_edit = new StringRequest(Request.Method.POST, strposturl_2,
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
                            Log.v("error account edit","account edit error");
                        else{
                            Log.v("account edit success","account edit success");
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
                hashMap.put("password",password_edit.getText().toString());
                hashMap.put("phone",phone_edit.getText().toString());
                hashMap.put("name",name_edit.getText().toString());
                hashMap.put("user_id",id_edit.getText().toString());
                return hashMap;
            }
        };
    }
    private boolean checkCardId(String id) {
        if (!id.matches("[a-zA-Z][1-2][0-9]{8}")) {
            return false;
        }

        String newId = id.toUpperCase();
        //身分證第一碼代表數值
        int[] headNum = new int[]{
                1, 10, 19, 28, 37,
                46, 55, 64, 39, 73,
                82, 2, 11, 20, 48,
                29, 38, 47, 56, 65,
                74, 83, 21, 3, 12, 30};

        char[] headCharUpper = new char[]{
                'A', 'B', 'C', 'D', 'E', 'F', 'G',
                'H', 'I', 'J', 'K', 'L', 'M', 'N',
                'O', 'P', 'Q', 'R', 'S', 'T', 'U',
                'V', 'W', 'X', 'Y', 'Z'
        };

        int index = Arrays.binarySearch(headCharUpper, newId.charAt(0));
        int base = 8;
        int total = 0;
        for (int i = 1; i < 10; i++) {
            int tmp = Integer.parseInt(Character.toString(newId.charAt(i))) * base;
            total += tmp;
            base--;
        }

        total += headNum[index];
        int remain = total % 10;
        int checkNum = (10 - remain) % 10;
        if (Integer.parseInt(Character.toString(newId.charAt(9))) != checkNum) {
            return false;
        }
        return true;
    }
    public void showdialog(){
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("身分證字號碼錯誤");
        dialog.setMessage("您輸入的身分證字號不是有效的身分證字號碼");
        dialog.setNegativeButton("確認",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface arg0, int arg1) {
                // TODO Auto-generated method stub
            }

        });
        dialog.show();
    }
}
