package com.bilab.lunsenluandroid;


import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
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
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.HashMap;

import androidx.appcompat.app.AppCompatActivity;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import javax.net.ssl.SSLSocketFactory;

public class RegisterActivity extends AppCompatActivity {

    EditText name,phone,email,password,password_check;
    Button logout_button;
    ImageView previous;
    TextView register_error;
    private RequestQueue objpostqueue;
    private StringRequest register_postRequest;
    private final static String strposturl = "https://lunsenlu.cf:8443/account/register";//"https://140.124.183.197:8000/account/register";
    String request_result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.register);
        name =  (EditText) findViewById(R.id.logout_name);
        phone =  (EditText) findViewById(R.id.logout_phone);
        email =  (EditText) findViewById(R.id.logout_email);
        password =  (EditText) findViewById(R.id.logout_password);
        password_check =  (EditText) findViewById(R.id.logout_password_check);
        logout_button =  (Button) findViewById(R.id.logout_button);
        previous =  (ImageView) findViewById(R.id.register_previous);
        register_error = (TextView) findViewById(R.id.register_error);
        //HTTPSTrustManager.allowAllSSL();
        //objpostqueue = Volley.newRequestQueue(this);
        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);
        request_post_api();

        logout_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(password.getText().toString().equals(password_check.getText().toString()) ){
                    objpostqueue.add(register_postRequest);
                }
                else
                    register_error.setText("密碼請輸入一致");
            }
        });
        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }

    public void request_post_api(){
        register_postRequest = new StringRequest(Request.Method.POST, strposturl,
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
                            register_error.setText("此帳戶已有人註冊");
                        else{
                            String masterKeyAlias = null;
                            try {
                                masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
                                SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                                        "RoadOfLifeAccount",
                                        masterKeyAlias,
                                        RegisterActivity.this,
                                        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                                        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                                );
                                sharedPreferences.edit().putString("email", email.getText().toString()).apply();
                                sharedPreferences.edit().putString("password", password.getText().toString()).apply();
                            } catch (GeneralSecurityException | IOException e) {
                                e.printStackTrace();
                            }
                            /*SharedPreferences sharedPreferences = getSharedPreferences("RoadOfLifeAccount", MODE_PRIVATE);
                            SharedPreferences.Editor myEdit = sharedPreferences.edit();
                            myEdit.putString("email", email.getText().toString());
                            myEdit.putString("password", password.getText().toString());
                            myEdit.commit();*/
                            Intent intent = new Intent();
                            final Bundle bundle = new Bundle();
                            intent.setClass(RegisterActivity.this, Main2Activity.class);
                            startActivity(intent);
                            RegisterActivity.this.finish();
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

                hashMap.put("email",email.getText().toString());
                hashMap.put("password",password.getText().toString());
                hashMap.put("phone",phone.getText().toString());
                hashMap.put("name",name.getText().toString());

                return hashMap;
            }
        };
    }
}
