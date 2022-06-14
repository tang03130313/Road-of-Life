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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }
}
