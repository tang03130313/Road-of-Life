// 20190709 建置整個專案
//          一、 環境限制-SDK 限制 -> 加入okhttp與gson套件 + 匯入Library nhisdk.aar、dexguard-runtime.aar
// 20190710 三、 相關設定-開啟「健保快易通」APP
// 20190711 四、SDK初始化作業 -> 初始化： MHB.configure() + 服務啟動： MHB. startProc()
// 20190712 取得新的介接文件
//          五、取得檔案作業-取得File_Ticket
// 20190718 Unix TimeStamp時間 只會轉成GMT的時區，改成現在的時區
// 20190730 使用zipJ4上有問題，最新版本2.1.1會造成Error: Invoke-customs are only supported starting with Android O (--min-api 26)
//              解決方法
//              a.降低版本至1.3.2    b.解決error
// 20190731 使用方法a解決zipJ4的問題
//          五、取得檔案作業-實作取檔 call -> 解壓縮stream的zip，並讀取zip文件裡的json檔案內容
// 20190805 重創專案並簡化程式碼
//              操作 > 1. 創建專案
//              操作 > 2.簽名APK&上架&更改version(未來在放上)
//              操作 > 3. SDK限制
//              操作 > 4. 設定可直接開啟「健保快易通」APP
// 20190808 簡化程式碼
//              操作 > 5. SDK 初始化作業
//              操作 > 6. 取得檔案作業(檔案識別碼遞迴查尋)
// 20190814 簡化程式碼
//              操作 > 6. 取得檔案作業(zipJ4、取檔函式)
// 20190815 取檔取得最新的檔案
//          分檔
// 20190821 程式碼弄得彈性些(關於fileTicketName)
// 20190828 SharedPreferences本地端之檔案數已達上限，搬走檔案
// 20191120 新改版SDK以及新解密檔案方式
//          移除匯入的Library nhisdk.aar、dexguard-runtime.aar，然後匯入新版本的
//          實作金鑰產生 + 新解密檔案方式


// 未來進度
// (ok) 1. 時間戳記 目前只會轉成GMT的時區，要改成現在的時區
// (ok) 2. 五、取得檔案作業-實作取檔 callback
// (ok)3. 本地端之檔案數已達上限，如何搬走檔案 -> SharedPreferences檔案儲存的位置不知道在哪
// (ok) 4. 使用zipJ4上有問題，最新版本2.1.1會造成Error: Invoke-customs are only supported starting with Android O (--min-api 26)
//      解決方法
//      a.降低版本至1.3.2    b.解決error
// (ok)5. 程式碼弄得彈性些(關於fileTicketName)
// (ok)6. 取檔取得最新的檔案
//      讀取順序從新到舊，現在的讀取方式會解讀到舊的
// (ok)(暫時沒找到，卡在解壓縮密碼，繼續使用zip4j)7. 如何不用zip4j達成取檔
// (ok)8. MHB mhb = MHB.configure(context,apiKey); 必須寫在try catch裡面，要怎麼分檔案?
// 9. fetch data不能寫在function外面，會存取不到解壓縮後的資料，因此要解壓縮的同時要上傳(線程)
// 遭遇過的困難


package com.bilab.lunsenluandroid;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.nhi.mhbsdk.MHB;

import net.lingala.zip4j.io.inputstream.ZipInputStream;
import net.lingala.zip4j.model.LocalFileHeader;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.net.ssl.SSLSocketFactory;


public class MainActivity extends AppCompatActivity {
    public String apiKey = "8bf841483aba48129bb6d0d851da9075";
    public Context context = MainActivity.this;
    TextView text;
    Button b1, b2, b3;
    public String fileTicketName = null;

    private static RequestQueue objpostqueue;
    private static StringRequest postRequest;
    private final static String strposturl_insert_health_passport = "https://140.124.183.191:8080/health_passport/insert_health_passport";
    String request_result,target_email,target_password,request_id = "",pass_json="";
    StringBuffer dataBuffer;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        text = (TextView)findViewById(R.id.text);
        b1=(Button)findViewById(R.id.button);
        b2=(Button)findViewById(R.id.button2);
        b3=(Button)findViewById(R.id.button3);

        //objpostqueue = Volley.newRequestQueue(this);
        //HTTPSTrustManager.allowAllSSL();
        //生成SSLSocketFactory
        SSLSocketFactory sslSocketFactory = HTTPSTrustManager.initSSLSocketFactory(this);
        //HurlStack两个参数默认都是null,如果传入SSLSocketFactory，那么会以Https的方式来请求网络
        HurlStack stack = new HurlStack(null, sslSocketFactory);
        //传入处理Https的HurlStack
        objpostqueue = Volley.newRequestQueue(this,stack);

        initial();


        try {
            // 服務啟動Android MHB Class
            final MHB mhb = MHB.configure(context,apiKey);

            // 服務啟動，起始Android畫面
            mhbStartProcFunc(mhb);


            b1.setOnClickListener(new Button.OnClickListener(){
                @Override
                public void onClick(View v) {
                    HashMap mhbGetFileName = mhbGetFileNameFunc();   // 檔案識別碼遞回查尋
                    String newestFileName = (String)mhbGetFileName.get("newestFileName"); // 最新的檔案的fileName
                    if(newestFileName == null){ // 沒有資料
                        text.append("請去下載健康存摺資料\n");
                    }
                    fileTicketName = newestFileName;
                }
            });

            // 實作取檔 callback
            b2.setOnClickListener(new Button.OnClickListener(){
                @Override
                public void onClick(View view) {
                    // fetch data不能寫在function外面，會存取不到解壓縮後的資料，因此要解壓縮的同時要上傳(線程)
                    StringBuffer dataBuffer = mhbFetchDataFunc(mhb, fileTicketName);
                    text.append("testBufferPrint\n");
                    text.append(dataBuffer);

                    /*
                    // 實作取檔 callback
                    mhb.fetchData(fileTicketName, new MHB.FetchDataCallback() {
                        @Override
                        public void onFetchDataSuccess(FileInputStream fis, String serverKey){
                            // 第三方APP自行處理zip檔案接收與解密
                            // 解密時，需以[Api_Key][Server_Key]組成字串做為解密金鑰，之後以此解密金鑰來解密該檔案，並將結果儲存為.json檔
                            text.append("fileTicketName : " + fileTicketName + "\n");
                            text.append("serverKey : " + serverKey + "\n");
                            String password = apiKey + serverKey;

                            LocalFileHeader localFileHeader;
                            try (ZipInputStream zipInputStream = new ZipInputStream(fis, password.toCharArray())) {
                                while ((localFileHeader = zipInputStream.getNextEntry()) != null) {
                                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(zipInputStream));
                                    String line;

                                    // 取得檔案名稱
                                    File extractedFile = new File(localFileHeader.getFileName());
                                    text.append("extractedFile " + extractedFile +"\n");

                                    // 取得檔案內容
                                    while ((line = bufferedReader.readLine()) != null) {
                                        text.append(line);
                                    }
                                }
                            } catch (IOException e) {
                                text.append("IOException e : "+e);
                                e.printStackTrace();
                            }
                        }
                        @Override
                        public void onFetchDataFailure(String errorCode){
                            //回傳Error Code
                            text.setText("Error Code : "+errorCode);
                        }
                    });
                */

                }
            });

            // 刪除最舊的檔案
            b3.setOnClickListener(new Button.OnClickListener(){
                @Override
                public void onClick(View v) {
                    HashMap mhbGetFileName = mhbGetFileNameFunc();   // 檔案識別碼遞回查尋
                    String oldestFileName = (String)mhbGetFileName.get("oldestFileName"); // 最新的檔案的fileName

                    if(oldestFileName == null){ // 沒有資料
                        text.append("請去下載健康存摺資料\n");
                    }

                    // 刪除最舊的檔案
                    //初始化SharedPreferences
                    SharedPreferences sharedPreferences= getSharedPreferences(context.getPackageName(),
                            Activity.MODE_PRIVATE);
                    sharedPreferences.edit().remove(oldestFileName).commit();
                    text.append("刪除最舊的檔案 : " + oldestFileName + "\n");

                }
            });

        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    /***************************************
     * 服務啟動，起始Android畫面
     ****************************************/
    public void mhbStartProcFunc(MHB mhb){
        mhb.startProc(new MHB.StartProcCallback(){
            @Override
            public void onStarProcSuccess(){
                // 畫面已初始化呈現於第三方APP
                text.setText("onUIProcStart"+"\n");
            }
            @Override
            public void onStartProcFailure(String errorCode){
                // 回傳Error Code
                text.setText("Error Code : "+errorCode+"\n");
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
        SharedPreferences sharedPreferences= getSharedPreferences(context.getPackageName(),
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
        }

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
                    text.append("ParseException e : "+e + "\n");
                }
            }
            // 確認最新的答案
            text.append("newestFileName : " + newestFileName+"\n");
            text.append("newestDate : " + newestDate + "\n");
            text.append("oldestFileName : " + oldestFileName + "\n");
            text.append("oldestDate : " + oldestDate + "\n");

        }


        text.append("fileNameList : " + fileNameList + "\n");

        // 回傳結果
        mhbGetFileName.put("fileNameList", fileNameList);
        mhbGetFileName.put("newestFileName", newestFileName);
        mhbGetFileName.put("oldestFileName", oldestFileName);

        return mhbGetFileName;
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
                text.append("fileName : " + fileName + "\n");
                text.append("serverKey : " + serverKey + "\n");
                //String password = apiKey + serverKey;
                String password = mhbGetFinalKey(apiKey, serverKey);

                LocalFileHeader localFileHeader;
                try (ZipInputStream zipInputStream = new ZipInputStream(fis, password.toCharArray())) {
                    while ((localFileHeader = zipInputStream.getNextEntry()) != null) {
                        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(zipInputStream));
                        String line;

                        // 取得檔案名稱
                        File extractedFile = new File(localFileHeader.getFileName());
                        text.append("extractedFile " +localFileHeader+" "+ extractedFile +"\n");

                        // 取得檔案內容
                        while ((line = bufferedReader.readLine()) != null) {
                            dataBuffer.append(line);
                            text.append(line);
                        }

                    }
                    objpostqueue.add(postRequest);
                    dataBuffer.delete(0,1);
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(0)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(1)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(2)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(3)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(4)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(5)));
                    Log.v("aaa",String.valueOf(dataBuffer.charAt(6)));
                    Log.v("pass buffer",dataBuffer.toString());
                    Log.v("pass str",pass_json);
                } catch (IOException e) {
                    text.append("IOException e : "+e);
                    e.printStackTrace();
                }
            }
            @Override
            public void onFetchDataFailure(String errorCode){
                //回傳Error Code
                text.setText("Error Code : "+errorCode);
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


    public void initial(){
        target_email = "test@gmail.com";
        target_password = "Test";
        Log.v("bbb",target_password);
        postRequest = new StringRequest(Request.Method.POST, strposturl_insert_health_passport,
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
                hashMap.put("user_id","A114236551");
                hashMap.put("email",target_email);
                hashMap.put("password",target_password);
                hashMap.put("passport_json",dataBuffer.toString());
                return hashMap;
            }
        };
    }
}
