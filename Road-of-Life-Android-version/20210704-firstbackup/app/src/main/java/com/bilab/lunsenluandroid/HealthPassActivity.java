package com.bilab.lunsenluandroid;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.text.format.DateFormat;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
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
import com.bilab.lunsenluandroid.Adapter.RecycleViewHealthPass;
import com.bilab.lunsenluandroid.model.HPData;
import com.nhi.mhbsdk.MHB;
import com.wang.avi.AVLoadingIndicatorView;

import net.lingala.zip4j.io.inputstream.ZipInputStream;
import net.lingala.zip4j.model.LocalFileHeader;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.net.ssl.SSLSocketFactory;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.NotificationCompat;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

public class HealthPassActivity extends AppCompatActivity {
    public String apiKey = "";//8bf841483aba48129bb6d0d851da9075
    public Context context = HealthPassActivity.this;
    public String fileTicketName = null;

    private NotificationManager mNotifyManager;
    private NotificationCompat.Builder mBuilder;
    int prcess_left = 0;

    AVLoadingIndicatorView avi;
    Handler handler = new Handler( );
    Runnable runnable;

    ImageView previous;
    RecyclerView recyclerView;
    TextView passport_empty,health_main_edit,health_main_finish;
    Button health_pass_insert;
    AVLoadingIndicatorView loading;
    ScrollView recycler_view;

    private static final String TAG = "MainActivity";
    public  static RecycleViewHealthPass adapter;

    private static RequestQueue objpostqueue;
    private static StringRequest postRequest,postRequest_remove,postRequest_checkid,postRequest_insert,getRequest_getkey;
    private final static String strposturl_get = "https://lunsenlu.cf/health_passport/get_health_passport";//"https://140.124.183.197:8000/health_passport/get_health_passport";
    private final static String strposturl_remove = "https://lunsenlu.cf/health_passport/delete_health_passport";//"https://140.124.183.197:8000/health_passport/delete_health_passport";
    private final static String strposturl_checkid = "https://lunsenlu.cf/account/check_id";//"https://140.124.183.197:8000/account/check_id";
    private final static String strposturl_insert_health_passport = "https://lunsenlu.cf/health_passport/insert_health_passport";//"https://140.124.183.197:8000/health_passport/insert_health_passport";
    private final static String strposturl_get_api= "https://lunsenlu.cf/health_passport/get_api";//"https://140.124.183.197:8000/health_passport/get_api";
    String request_result,target_email,target_password,request_id = "";
    static String target_selected,target_new = "";
    Boolean target_edit = false,bool_new_json = false;
    private static int target_position;
    static List<HPData>  postData = new ArrayList<>();
    long time;
    SharedPreferences sh;
    StringBuffer dataBuffer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.healthpassport_main);
        getSupportActionBar().hide();
        Intent intent = this.getIntent();
        String activity = intent.getStringExtra("activity");

        previous =  (ImageView) findViewById(R.id.health_passport_previous);
        recyclerView = findViewById(R.id.pass_recycler_view);
        passport_empty = findViewById(R.id.passport_empty);
        health_main_edit = findViewById(R.id.health_main_edit);
        health_main_finish= findViewById(R.id.health_main_finish);
        health_pass_insert = findViewById(R.id.health_pass_insert);
        loading = findViewById(R.id.passport_loading);
        recycler_view = findViewById(R.id.recycler_view);
        loading.smoothToShow();

        //objpostqueue = Volley.newRequestQueue(this);
        //HTTPSTrustManager.allowAllSSL();
        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        initial();
        objpostqueue.add(getRequest_getkey);
        objpostqueue.add(postRequest_checkid);

        mNotifyManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mBuilder = new NotificationCompat.Builder(HealthPassActivity.this);
        mBuilder.setContentTitle("下載健康存摺")
                .setContentText("下載中...")
                .setSmallIcon(R.drawable.book_download);
        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(activity==null)
                    finish();
                else{
                    Log.v("aaa",activity);
                    Intent intent = new Intent();
                    intent.setClass(HealthPassActivity.this, Main2Activity.class);
                    startActivity(intent);
                }
            }
        });
        health_main_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                health_main_edit.setVisibility(View.GONE);
                health_main_finish.setVisibility(View.VISIBLE);
                target_edit = true;
                objpostqueue.add(postRequest);
            }
        });
        health_main_finish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                health_main_finish.setVisibility(View.GONE);
                health_main_edit.setVisibility(View.VISIBLE);
                target_edit = false;
                objpostqueue.add(postRequest);
            }
        });

        try {
            final MHB mhb = MHB.configure(context,apiKey);
            health_pass_insert.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(request_id.equals("")){
                        showdialog();
                    }
                    else if(target_new.equals("")) {
                        mhbStartProcFunc(mhb);
                    }

                }
            });
            runnable = new Runnable( ) {
                public void run ( ) {
                    HashMap mhbGetFileName = mhbGetFileNameFunc();   // 檔案識別碼遞回查尋
                    String newestFileName = (String)mhbGetFileName.get("newestFileName"); // 最新的檔案的fileName
                    //Log.v("aaa",bool_new_json+" "+newestFileName+" : "+(System.currentTimeMillis()-time)/1000);
                    fileTicketName = newestFileName;
                    if(fileTicketName != null){
                        mBuilder.setContentText("下載中...").setProgress(100, prcess_left, false);
                        mNotifyManager.notify(0, mBuilder.build());
                        time = System.currentTimeMillis();
                        String masterKeyAlias = null;
                        try {
                            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
                            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                                    "RoadOfLifeAccount",
                                    masterKeyAlias,
                                    HealthPassActivity.this,
                                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                            );
                            target_new = sharedPreferences.getString("new_filename", "");
                            if(target_new.equals("")){
                                sharedPreferences.edit().putString("new_filename", fileTicketName).apply();
                                target_new = sharedPreferences.getString("new_filename", "");
                            }
                        } catch (GeneralSecurityException | IOException e) {
                            e.printStackTrace();
                        }
                        /*sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
                        target_new = sh.getString("new_filename","");
                        if(target_new.equals("")){
                            SharedPreferences.Editor myEdit = sh.edit();
                            myEdit.putString("new_filename",fileTicketName);
                            myEdit.apply();
                            target_new = sh.getString("new_filename","");
                        }*/
                        StringBuffer dataBuffer = mhbFetchDataFunc(mhb, fileTicketName);
                        Log.v("aaa","testBufferPrint\n");
                        Log.v("aaa",dataBuffer.toString());
                        //objpostqueue.add(postRequest);
                        if(bool_new_json){
                            handler.postDelayed(this,2000);
                        }
                        else
                            handler.postDelayed(this,20000);
                        objpostqueue.add(postRequest);
                        //recycler_view.fullScroll(ScrollView.FOCUS_DOWN);
                        prcess_left = (prcess_left+20 >= 80)?80:prcess_left+20;
                    }
                    else{
                        handler.postDelayed(this,2000);
                    }

                    if(bool_new_json){
                        mBuilder.setContentText("下載完成").setProgress(0,0,false);
                        prcess_left= 0;
                        mNotifyManager.notify(0, mBuilder.build());
                        SharedPreferences.Editor myEdit = sh.edit();
                        myEdit.putString("new_filename","");
                        myEdit.apply();
                        target_new = "";
                        objpostqueue.add(postRequest);
                        bool_new_json = false;
                        Log.v("total_time",bool_new_json+" "+newestFileName+" : "+(System.currentTimeMillis()-time)/1000);
                    }
                    //time = System.currentTimeMillis();

                    //postDelayed(this,2000)方法安排一个Runnable对象到主线程队列中
                }
            };
            handler.postDelayed(runnable,2000);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void initial(){
        String masterKeyAlias = null;
        try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount",
                    masterKeyAlias,
                    HealthPassActivity.this,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            target_email = sharedPreferences.getString("email", "");
            target_password = sharedPreferences.getString("password","");
            target_selected = sharedPreferences.getString("selected","");
            if(target_selected.equals("")){
                sharedPreferences.edit().putString("selected", "1").apply();
                target_selected = sharedPreferences.getString("selected","");
            }
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        /*sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
        target_email = sh.getString("email","");
        target_password = sh.getString("password","");
        target_selected = sh.getString("selected","");
        SharedPreferences.Editor myEdit = sh.edit();
        if(target_selected.equals("")){
            myEdit.putString("selected", "1");
            myEdit.commit();
            target_selected = sh.getString("selected","");
        }*/
        Log.v("bbb",target_selected);
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
                        if(request_result.equals("fail")){
                            Log.v("error account checkid ", "account checkid  error");
                            loading.setVisibility(View.GONE);
                            passport_empty.setVisibility(View.VISIBLE);
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
                        postData = new ArrayList<>();
                        boolean check_new_download = target_new.equals("");

                        if(request_result.equals("fail")) {
                            Log.v("error account main", "account main錯誤");
                            if(check_new_download){
                                recycler_view.setVisibility(View.GONE);
                                loading.setVisibility(View.GONE);
                                passport_empty.setVisibility(View.VISIBLE);
                            }
                            else
                                new_download();
                        }
                        else{
                            try {
                                passport_empty.setVisibility(View.GONE);
                                loading.setVisibility(View.GONE);
                                recycler_view.setVisibility(View.VISIBLE);
                                if(!check_new_download){
                                    new_download();
                                    /*if(target_selected.equals("") || target_selected.equals("1")){
                                        myEdit.putString("selected", "2");
                                        myEdit.commit();
                                        target_selected = sh.getString("selected","");
                                    }*/
                                }
                                JSONObject jsonObject=new JSONObject(response);
                                Log.v("length json",String.valueOf(jsonObject.length()));
                                for(int i = 1; i < jsonObject.length();i++){
                                    JSONArray jsonarray = jsonObject.getJSONArray(String.valueOf(i));
                                    Log.v("jsonaaa"+i,String.valueOf(jsonarray));
                                    HPData data = new HPData();
                                    data.setId(i);
                                    data.setTime(jsonarray.get(0).toString());
                                    data.setDetail(jsonarray.get(1).toString());
                                    data.setState(target_selected.equals(String.valueOf(i)) ? 0 : 1);
                                    data.setEdit(target_edit);
                                    postData.add(data);
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            initRecyclerView();
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
        postRequest_insert = new StringRequest(Request.Method.POST, strposturl_insert_health_passport,
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
                            Log.v("pass_json error ", "pass_json  error");
                        else{
                            Log.v("pass_json success", "pass_json success");
                            Log.v("passport",dataBuffer.toString());
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
                hashMap.put("user_id",request_id);
                hashMap.put("passport_json",dataBuffer.toString());
                Log.v("insert_health_email",target_email);
                Log.v("insert_health_password",target_password);
                Log.v("insert_health_id",request_id);
                Log.v("insert_health_json",dataBuffer.toString());
                return hashMap;
            }
        };
        getRequest_getkey = new StringRequest(Request.Method.GET, strposturl_get_api,
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
                            Log.v("pass_json error ", "pass_json  error");
                        else{
                            Log.v("pass_json success", "pass_json success");
                            Log.v("passport",request_result);
                            apiKey = request_result.toString();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //如果發生錯誤，就是回傳VolleyError，可以顯示是什麼錯誤。
                Log.v("error",error.getMessage());
            }
        });
    }

    public static void notifyAdapter(int position){
        target_position = position+1;
        objpostqueue.add(postRequest_remove);
        adapter.notifyDataSetChanged();
    }

    public static void notifyAdapter_2(int position){
        target_selected = String.valueOf(position);
        objpostqueue.add(postRequest);
        adapter.notifyDataSetChanged();
    }

    /*public void check_new_download(){
        sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
        target_new = sh.getString("new_filename","");
        if(!target_new.equals("")){
            passport_empty.setVisibility(View.GONE);
            loading.setVisibility(View.GONE);
            recycler_view.setVisibility(View.VISIBLE);
            Calendar mCal = Calendar.getInstance();
            CharSequence now_time = DateFormat.format("yyyy-MM-dd kk:mm:ss", mCal.getTime());
            HPData data = new HPData();
            data.setTime(now_time.toString());
            data.setDetail("下載中...");
            data.setState(2);
            data.setEdit(target_edit);
            postData.add(data);
            initRecyclerView();
        }
        else if (postData.size() > 0){
            initRecyclerView();
        }
    }*/
    public void new_download(){
        Calendar mCal = Calendar.getInstance();
        CharSequence now_time = DateFormat.format("yyyy-MM-dd kk:mm:ss", mCal.getTime());
        HPData data = new HPData();
        data.setTime(now_time.toString());
        data.setDetail("下載中...");
        data.setState(2);
        data.setEdit(target_edit);
        postData.add(data);
    }

    private void initRecyclerView(){
        Log.d(TAG, "initRecyclerView: init recyclerview."+target_new);
        adapter = new RecycleViewHealthPass(this, postData);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(new DefaultItemAnimator());
        recyclerView.setAdapter(adapter);
    }

    public void showdialog(){
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("您在個人資料身分證字號欄位為空");
        dialog.setMessage("因健康存摺需要使用您的身分證字號做查詢的動作，故請您按下確定跳轉到個人帳戶頁面輸入您的身分證字號，請放心我們並不會用在除健康存摺其他任何地方");
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
                intent.setClass(HealthPassActivity.this, AccountPasswordActivity.class);
                intent.putExtra("activity", "health_pass");
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(intent);
            }

        });
        dialog.show();
    }

    /***************************************
     * 服務啟動，起始Android畫面
     ****************************************/
    public void mhbStartProcFunc(MHB mhb){
        mhb.startProc(new MHB.StartProcCallback(){
            @Override
            public void onStarProcSuccess(){
                // 畫面已初始化呈現於第三方APP
                //text.setText("onUIProcStart"+"\n");
            }
            @Override
            public void onStartProcFailure(String errorCode){
                // 回傳Error Code
                //text.setText("Error Code : "+errorCode+"\n");
            }
        });
    }

    /***************************************
     * 檔案識別碼遞回查尋
     * @return
     * fileNameList     // 所有檔案的fileName
     * newestFileName   // 最新的檔案的fileName
     ****************************************/
    public HashMap mhbGetFileNameFunc(){
        HashMap mhbGetFileName = new HashMap(); // 回傳結果
        ArrayList fileNameList = new ArrayList();
        String newestFileName = null;   // 最新的檔案的fileName
        String newestDate = null;       // 最新的檔案的fileName的時間
        String oldestFileName = null;   // 最舊的檔案的fileName
        String oldestDate = null;       // 最舊的檔案的fileName的時間

        //初始化SharedPreferences
        String masterKeyAlias = null;
        try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount",
                    masterKeyAlias,
                    HealthPassActivity.this,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            Map<String, ?> allKey = sharedPreferences.getAll();
            for (Map.Entry<String, ?> entry : allKey.entrySet()) {
                String key = entry.getKey();
                if (key.startsWith("File_Ticket_")) {
                    // 可依已紀錄的起始／結束時間戳記區間內查詢前次SDK存入的檔案識別碼
                    // 順序從新到舊，只需存取最新的即可
                    fileNameList.add(key);
                }
            }

        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        /*SharedPreferences sharedPreferences= getSharedPreferences(context.getPackageName(),
                Activity.MODE_PRIVATE);

        //以下列出檔案識別碼遞回查尋範例供參考使用
        Map<String, ?> allKey = sharedPreferences.getAll();
        for (Map.Entry<String, ?> entry : allKey.entrySet()) {
            String key = entry.getKey();
            if (key.startsWith("File_Ticket_")) {
                // 可依已紀錄的起始／結束時間戳記區間內查詢前次SDK存入的檔案識別碼
                // 順序從新到舊，只需存取最新的即可
                fileNameList.add(key);
            }
        }*/

        // 取得最新和最舊的檔案的fileName
        if(!fileNameList.isEmpty()) {
            newestFileName = (String) fileNameList.get(0);
            newestDate = mhbGetFileTime(newestFileName);  // 取得fileName的時間
            oldestFileName = (String) fileNameList.get(0);
            oldestDate = mhbGetFileTime(newestFileName);  // 取得fileName的時間

            for (int i = 1; i < fileNameList.size(); i++) {
                String fileName = (String) fileNameList.get(i);
                String date = mhbGetFileTime(fileName);   // 取得fileName的時間
                try {
                    // 最新
                    if(compareDate(newestDate,date)) {   // 日期比較大小 // true : a早於b // false : a晚於b 或 a等於b
                        newestDate = date;
                        newestFileName = fileName;
                    }
                    // 最舊
                    else if(!compareDate(oldestDate,date)) {
                        oldestDate = date;
                        oldestFileName = fileName;
                    }
                } catch (ParseException e) {
                    //text.append("ParseException e : "+e + "\n");
                }
            }
            // 確認最新的答案
            /*Log.v("aaa","newestFileName : " + newestFileName+"\n");
            Log.v("aaa","newestDate : " + newestDate + "\n");
            Log.v("aaa","oldestFileName : " + oldestFileName + "\n");
            Log.v("aaa","oldestDate : " + oldestDate + "\n");*/

        }


        //Log.v("aaa","fileNameList : " + fileNameList + "\n");

        // 回傳結果
        mhbGetFileName.put("fileNameList", fileNameList);
        mhbGetFileName.put("newestFileName", newestFileName);
        mhbGetFileName.put("oldestFileName", oldestFileName);

        return mhbGetFileName;
    }
    /***************************************
     * 取得fileName的時間
     * @return
     * 日期格式 // "yyyy-MM-dd HH:mm:ss"
     ****************************************/
    public String mhbGetFileTime(String fileName){
        // 時間戳記(unix timestamp)轉乘long
        long lg = Long.parseLong(fileName.replace("File_Ticket_",""));
        // 轉成日期格式
        String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(lg));

        return date;
    }
    /***************************************
     * 日期比較大小
     * @return
     * true     // a早於b
     * false    // a晚於b 或 a等於b
     ****************************************/
    public boolean compareDate(String time1,String time2) throws ParseException
    {
        // 如果想比較日期則寫成"yyyy-MM-dd"就可以了
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // 將字符串形式的時間轉化為Date類型的時間
        Date a=sdf.parse(time1);
        Date b=sdf.parse(time2);

        /*
        // Date類的一個方法   // 流氓的方法
        // true : a早於b  // false : a晚於b 或 a等於b
        if(a.before(b))
            return true;
        else
            return false;
        */

        // 將Date轉換成毫秒
        // a-b < 0 : a早於b   // a-b > 0 : a晚於b   // a-b = 0 : a等於b
        if(a.getTime()-b.getTime()<0)
            return true;
        else
            return false;

    }
    /***************************************
     * 實作取檔 callback
     * @return
     * StringBuffer dataBuffer // 解壓縮的內容
     ****************************************/
    public StringBuffer mhbFetchDataFunc(MHB mhb, String fileName){
        dataBuffer = new StringBuffer();   // 回傳結果

        mhb.fetchData(fileName, new MHB.FetchDataCallback() {
            @Override
            public void onFetchDataSuccess(FileInputStream fis, String serverKey){
                // 第三方APP自行處理zip檔案接收與解密
                // 解密時，需以[Api_Key][Server_Key]組成字串做為解密金鑰，之後以此解密金鑰來解密該檔案，並將結果儲存為.json檔
                //Log.v("aaa","fileName : " + fileName + "\n");
                //Log.v("aaa","serverKey : " + serverKey + "\n");
                //String password = apiKey + serverKey;
                String password = mhbGetFinalKey(apiKey, serverKey);

                LocalFileHeader localFileHeader;
                try (ZipInputStream zipInputStream = new ZipInputStream(fis, password.toCharArray())) {
                    bool_new_json = true;
                    while ((localFileHeader = zipInputStream.getNextEntry()) != null) {
                        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(zipInputStream));
                        String line;

                        // 取得檔案名稱
                        File extractedFile = new File(localFileHeader.getFileName());
                        //Log.v("aaa","extractedFile " + extractedFile +"\n");

                        // 取得檔案內容
                        while ((line = bufferedReader.readLine()) != null) {
                            dataBuffer.append(line);
                            //Log.v("aaa",line);
                        }

                    }
                    dataBuffer.delete(0,1);
                    Log.v("dataBuffer",dataBuffer.toString());
                    objpostqueue.add(postRequest_insert);
                } catch (IOException e) {
                    Log.v("aaa","IOException e : "+e);
                    e.printStackTrace();
                }
            }
            @Override
            public void onFetchDataFailure(String errorCode){
                //回傳Error Code
                Log.v("aaa","Error Code : "+errorCode);
            }
        });
        return dataBuffer;
    }

    /***************************************
     * 實作金鑰產生
     * String password  // apiKey
     * String salt      // serverKey
     * @return
     * String fianlkey // 金鑰
     ****************************************/
    public String mhbGetFinalKey(String password, String salt){
        //String password = "0123456789abcdefghij0123456789ab";
        //String salt = "0123456789abcdefghij0123456789abcdefghij";
        //final key > 6PZXh9yqau7ZTag3yc33drm/N8ym3ZfcD3MXyyX58Cw=
        byte[] bytes = salt.getBytes(StandardCharsets.US_ASCII);
        SecretKeyFactory factory = null;
        try {
            factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        } catch (NoSuchAlgorithmException e2) {
            e2.printStackTrace();
        }
        KeySpec spec = new PBEKeySpec(password.toCharArray(), bytes, 1000, 256);
        SecretKey tmp = null;
        try {
            tmp = factory.generateSecret(spec);
        } catch (InvalidKeySpecException e2) {
            e2.printStackTrace();
        }
        String finalkey = Base64.encodeToString(tmp.getEncoded(), Base64.DEFAULT).trim();
        return finalkey;
    }


}
