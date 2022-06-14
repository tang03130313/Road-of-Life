package com.bilab.lunsenluandroid.ui.track;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TableRow;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.bilab.lunsenluandroid.HTTPSTrustManager;
import com.bilab.lunsenluandroid.HealthPassActivity;
import com.bilab.lunsenluandroid.LoginActivity;
import com.bilab.lunsenluandroid.R;
import com.bilab.lunsenluandroid.SSLTolerentWebViewClient;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.util.HashMap;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;

public class TrackFragment extends Fragment {

    private TrackViewModel pathViewModel;
    private WebView webView;
    TableRow tablerow_error;
    TextView choose;

    private static RequestQueue objpostqueue;
    private static StringRequest postRequest;
    private final static String strposturl_check_health_passport = "https://lunsenlu.cf/health_passport/check_health_passport";//"https://140.124.183.197:8000/health_passport/check_health_passport";
    String request_result,target_email,target_password;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        pathViewModel =
                ViewModelProviders.of(this).get(TrackViewModel.class);
        View root = inflater.inflate(R.layout.fragment_track, container, false);

        webView = root.findViewById(R.id.fragment_path_webView);
        tablerow_error = root.findViewById(R.id.fragment_path_error);
        choose = root.findViewById(R.id.track_choose);

        //objpostqueue = Volley.newRequestQueue(root.getContext());
        //HTTPSTrustManager.allowAllSSL();

        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(getActivity());
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this.getActivity(),stack);
        initial();
        objpostqueue.add(postRequest);

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        webView.setWebViewClient(
                new SSLTolerentWebViewClient()
        );

        //webView.loadUrl("https://www.bbc.com");
        //webView.loadUrl("https://140.124.183.188:2222/LSLDoctor/login/")
        //webView.loadUrl("https://1qigvox2btm9q6ppyry9wq-on.drv.tw/MyWebsite/temp/");
        webView.loadUrl("https://1qigvox2btm9q6ppyry9wq-on.drv.tw/MyWebsite/kidding/mobile.html");
        webView.flingScroll(0,500);
        tablerow_error.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity(), HealthPassActivity.class);
                intent.putExtra("activity", "main");
                startActivity(intent);
            }
        });
        choose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity(), HealthPassActivity.class);
                intent.putExtra("activity", "main");
                startActivity(intent);
            }
        });
        /*final TextView textView = root.findViewById(R.id.text_home);
        pathViewModel.getText().observe(this, new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });*/


        return root;
    }


    public void initial(){
        String masterKeyAlias = null;
            try {
            masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
            SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                    "RoadOfLifeAccount", masterKeyAlias, getActivity(),
                    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            );
            target_email = sharedPreferences.getString("email", "");
            target_password = sharedPreferences.getString("password", "");
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }
        /*SharedPreferences sh = this.getActivity().getSharedPreferences("RoadOfLifeAccount", Context.MODE_PRIVATE);
        target_email = sh.getString("email","");
        target_password = sh.getString("password","");
        Log.v("bbb",target_password);*/
        postRequest = new StringRequest(Request.Method.POST, strposturl_check_health_passport,
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
                            tablerow_error.setVisibility(View.VISIBLE);
                        }
                        else{
                            Log.v("success account checkid", "account checkid  success");
                            tablerow_error.setVisibility(View.GONE);
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
}