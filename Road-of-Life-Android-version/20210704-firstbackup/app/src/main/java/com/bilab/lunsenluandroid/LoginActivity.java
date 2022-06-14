package com.bilab.lunsenluandroid;


import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import androidx.appcompat.app.AppCompatActivity;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import javax.net.ssl.SSLSocketFactory;

public class LoginActivity extends AppCompatActivity {

    EditText editText_email, editText_password;
    Button login_button;
    TextView register,login_error,login_privacy;
    private RequestQueue objpostqueue;
    private StringRequest postRequest;
    private final static String strposturl = "https://lunsenlu.cf/account/login";//"https://140.124.183.197:8000/account/login";
    String request_result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.login);
        //Toolbar toolbar = findViewById(R.id.toolbar);
        //setSupportActionBar(toolbar);
        //HTTPSTrustManager.allowAllSSL();
        //objpostqueue = Volley.newRequestQueue(this);
        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        editText_email =  (EditText) findViewById(R.id.login_email);
        editText_password =  (EditText) findViewById(R.id.login_password);
        login_button =  (Button) findViewById(R.id.login_imageButton);
        register = (TextView) findViewById(R.id.login_register);
        login_error = (TextView) findViewById(R.id.login_error);
        login_privacy = (TextView) findViewById(R.id.login_privacy);

        login_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                objpostqueue.add(postRequest);
            }
        });

        login_privacy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(LoginActivity.this, PrivacyPolicy2Activity.class);
                startActivity(intent);
            }
        });

        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(LoginActivity.this, PrivacyPolicyActivity.class);
                startActivity(intent);
            }
        });

        check();
        request_post_api();
    }

    public void check(){
        String masterKeyAlias = null,email="",password="";
        try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount", masterKeyAlias, LoginActivity.this,
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            email = sharedPreferences.getString("email", "");
            password = sharedPreferences.getString("password", "");
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        /*SharedPreferences sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
        email = sh.getString("email","");
        password = sh.getString("password","");*/
        if(email.equals("") || password.equals("")){}
        else{
            Intent intent = new Intent();
            intent.setClass(LoginActivity.this, Main2Activity.class);
            startActivity(intent);
            LoginActivity.this.finish();
        }
    }

    public void request_post_api(){
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
                            login_error.setText("錯誤的帳戶或密碼");
                        else{
                            String masterKeyAlias = null;
                            try {
                                masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
                                SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                                        "RoadOfLifeAccount",
                                        masterKeyAlias,
                                        LoginActivity.this,
                                        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                                        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                                );
                                sharedPreferences.edit().putString("email", editText_email.getText().toString()).apply();
                                sharedPreferences.edit().putString("password", editText_password.getText().toString()).apply();
                            } catch (GeneralSecurityException | IOException e) {
                                e.printStackTrace();
                            }
                            /*SharedPreferences sharedPreferences = getSharedPreferences("RoadOfLifeAccount", MODE_PRIVATE);
                            SharedPreferences.Editor myEdit = sharedPreferences.edit();
                            myEdit.putString("email", editText_email.getText().toString());
                            myEdit.putString("password", editText_password.getText().toString());
                            myEdit.commit();*/
                            Intent intent = new Intent();
                            final Bundle bundle = new Bundle();
                            intent.setClass(LoginActivity.this, Main2Activity.class);
                            startActivity(intent);
                            LoginActivity.this.finish();
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

                hashMap.put("email",editText_email.getText().toString());
                hashMap.put("password",editText_password.getText().toString());

                return hashMap;
            }
        };
    }

}
