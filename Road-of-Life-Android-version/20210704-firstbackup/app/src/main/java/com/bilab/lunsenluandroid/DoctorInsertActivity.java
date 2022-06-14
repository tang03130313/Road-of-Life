package com.bilab.lunsenluandroid;


import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.net.ssl.SSLSocketFactory;

public class DoctorInsertActivity extends AppCompatActivity {

    ImageView previous;
    TextView doctor_auth_error;
    Button button_insert;
    Spinner spinner_hospitals,spinner_departments,spinner_doctors;
    String hospital="",department="",doctor="";
    private ArrayAdapter<String> listAdapter;

    private static RequestQueue objpostqueue;
    private static StringRequest postRequest_get_hospitals,postRequest_get_departments,postRequest_get_doctors,postRequest_check_repeat,postRequest_insert;
    private final static String strposturl_get_hospitals = "https://lunsenlu.cf:8443/doctor/get_hospitals";//"https://140.124.183.197:8000/doctor/get_hospitals";
    private final static String strposturl_get_departments = "https://lunsenlu.cf:8443/doctor/get_departments";//"https://140.124.183.197:8000/doctor/get_departments";
    private final static String strposturl_get_doctors = "https://lunsenlu.cf:8443/doctor/get_doctors";//"https://140.124.183.197:8000/doctor/get_doctors";
    private final static String strposturl_check_repeat = "https://lunsenlu.cf:8443/doctor/check_repeat";//"https://140.124.183.197:8000/doctor/check_repeat";
    private final static String strposturl_insert= "https://lunsenlu.cf:8443/doctor_auth/insert_doctor_auth";//"https://140.124.183.197:8000/doctor_auth/insert_doctor_auth";
    String request_result,request_id = "";

    StringBuffer buf = new StringBuffer();

    ArrayList<String> arraylist = new ArrayList<String>();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.doctor_insert);
        getSupportActionBar().hide();

        previous =  (ImageView) findViewById(R.id.doctor_insert_previous);
        button_insert = (Button) findViewById(R.id.doctor_insert_button);
        spinner_hospitals = (Spinner) findViewById(R.id.doctor_insert_spinner_hospitals);
        spinner_departments = (Spinner) findViewById(R.id.doctor_insert_spinner_departments);
        spinner_doctors = (Spinner) findViewById(R.id.doctor_insert_spinner_doctors);
        doctor_auth_error = (TextView) findViewById(R.id.doctor_auth_error);

        Bundle bundle = getIntent().getExtras();
        if(bundle != null)
            request_id = bundle.getString("id") != null ? bundle.getString("id") : "";

        //objpostqueue = Volley.newRequestQueue(this);
        //HTTPSTrustManager.allowAllSSL();
        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        initial();
        objpostqueue.add(postRequest_get_hospitals);

        arraylist.add("請選擇項目");

        listAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, arraylist);
        spinner_hospitals.setAdapter(listAdapter);
        listAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, arraylist);
        spinner_departments.setAdapter(listAdapter);
        listAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, arraylist);
        spinner_doctors.setAdapter(listAdapter);

        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        spinner_hospitals.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView adapterView, View view, int position, long id) {
                //Toast.makeText(DoctorInsertActivity.this, "你選的是"+spinner_hospitals.getSelectedItem().toString(), Toast.LENGTH_SHORT).show();
                hospital = spinner_hospitals.getSelectedItem().toString();
                if(!hospital.equals("請選擇項目"))
                    objpostqueue.add(postRequest_get_departments);
            }
            @Override
            public void onNothingSelected(AdapterView arg0) {
                //Toast.makeText(DoctorInsertActivity.this, "您沒有選擇任何項目", Toast.LENGTH_LONG).show();
            }
        });

        spinner_departments.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView adapterView, View view, int position, long id) {

                department = spinner_departments.getSelectedItem().toString();
                if(!department.equals("請選擇項目")) {
                    objpostqueue.add(postRequest_get_doctors);
                }
            }
            @Override
            public void onNothingSelected(AdapterView arg0) {
                //Toast.makeText(DoctorInsertActivity.this, "您沒有選擇任何項目", Toast.LENGTH_LONG).show();
            }
        });

        spinner_doctors.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView adapterView, View view, int position, long id) {
                //Toast.makeText(DoctorInsertActivity.this, "你選的是"+spinner_doctors.getSelectedItem().toString(), Toast.LENGTH_SHORT).show();
                doctor = spinner_doctors.getSelectedItem().toString();
                if(!doctor.equals("請選擇項目"))
                    objpostqueue.add(postRequest_check_repeat);
            }
            @Override
            public void onNothingSelected(AdapterView arg0) {
                //Toast.makeText(DoctorInsertActivity.this, "您沒有選擇任何項目", Toast.LENGTH_LONG).show();
            }
        });

        button_insert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if(request_result.equals("success_select")){
                    objpostqueue.add(postRequest_insert);
                    Intent intent = new Intent();
                    intent.setClass(DoctorInsertActivity.this, DoctorAuthActivity.class);
                    startActivity(intent);
                    finish();
                }
            }
        });
    }

    public void initial(){
        postRequest_get_hospitals = new StringRequest(Request.Method.GET, strposturl_get_hospitals,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONArray jsonArray=new JSONArray(response);
                            arraylist = new ArrayList<String>();
                            arraylist.add("請選擇項目");
                            for(int i = 0;i < jsonArray.length();i++){
                                arraylist.add(jsonArray.getString(i));
                            }
                            setlistAdapter(spinner_hospitals);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //如果發生錯誤，就是回傳VolleyError，可以顯示是什麼錯誤。
                Log.v("error",error.getMessage());
            }
        });
        postRequest_get_departments = new StringRequest(Request.Method.POST, strposturl_get_departments,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONArray jsonArray=new JSONArray(response);
                            arraylist = new ArrayList<String>();
                            arraylist.add("請選擇項目");
                            for(int i = 0;i < jsonArray.length();i++){
                                arraylist.add(jsonArray.getString(i));
                            }
                            setlistAdapter(spinner_departments);
                            arraylist = new ArrayList<String>();
                            arraylist.add("請選擇項目");
                            setlistAdapter(spinner_doctors);
                        } catch (JSONException e) {
                            e.printStackTrace();
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
                hashMap.put("hospital",hospital);

                return hashMap;
            }
        };
        postRequest_get_doctors = new StringRequest(Request.Method.POST, strposturl_get_doctors,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        //response，表示是回傳值，就是API要回傳的字串，也可以是JSON字串。
                        try {
                            JSONArray jsonArray=new JSONArray(response);
                            arraylist = new ArrayList<String>();
                            arraylist.add("請選擇項目");
                            for(int i = 0;i < jsonArray.length();i++){
                                arraylist.add(jsonArray.getString(i));
                            }
                            setlistAdapter(spinner_doctors);
                        } catch (JSONException e) {
                            e.printStackTrace();
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

                hashMap.put("hospital",hospital);
                hashMap.put("department",department);
                return hashMap;
            }
        };
        postRequest_check_repeat = new StringRequest(Request.Method.POST, strposturl_check_repeat,
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
                        if(request_result.equals("repeat")) {
                            Log.v("error check_repeat", "account check_repeat error");
                            doctor_auth_error.setText("所選的醫生已在授權名單內");
                        }
                        else{
                            Log.v("success check_repeat", "account check_repeat success");
                            request_result = "success_select";
                            doctor_auth_error.setText("");
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

                hashMap.put("hospital",hospital);
                hashMap.put("department",department);
                hashMap.put("name",doctor);
                hashMap.put("user_id",request_id);
                return hashMap;
            }
        };
        postRequest_insert = new StringRequest(Request.Method.POST, strposturl_insert,
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
                        if(request_result.equals("repeat")) {
                            Log.v("error check_repeat", "account check_repeat error");
                            doctor_auth_error.setText("所選的醫生已在授權名單內");
                        }
                        else{
                            Log.v("success check_repeat", "account check_repeat success");
                            request_result = "success_select";
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

                hashMap.put("hospital",hospital);
                hashMap.put("department",department);
                hashMap.put("name",doctor);
                hashMap.put("user_id",request_id);
                return hashMap;
            }
        };
    }

    public void setlistAdapter(Spinner spinner){
        listAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, arraylist);
        spinner.setAdapter(listAdapter);
    }
}
