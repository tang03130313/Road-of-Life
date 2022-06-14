package com.bilab.lunsenluandroid;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.net.http.SslError;
import android.util.Log;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;


public class SSLTolerentWebViewClient extends WebViewClient {
    @Override
    public void onReceivedSslError(WebView view, @NonNull SslErrorHandler handler, SslError error) {
        if (BuildConfig.DEBUG) {
            handler.proceed();      // ignore in debug builds
        } else {
            Log.e("SSL error: " + error.toString(),"SSL error: " + error.toString());
        }
    }
}
    /*public void onReceivedSslError(WebView view, final SslErrorHandler handler, SslError error) {
        //final AlertDialog.Builder builder = new AlertDialog.Builder(context);
        //AlertDialog alertDialog = builder.create();
        String message = "SSL Certificate error.";
        switch (error.getPrimaryError()) {
            case SslError.SSL_UNTRUSTED:
                message = "The certificate authority is not trusted.";
                break;
            case SslError.SSL_EXPIRED:
                message = "The certificate has expired.";
                break;
            case SslError.SSL_IDMISMATCH:
                message = "The certificate Hostname mismatch.";
                break;
            case SslError.SSL_NOTYETVALID:
                message = "The certificate is not yet valid.";
                break;
        }

        message += " Do you want to continue anyway?";*/
        /*alertDialog.setTitle("SSL Certificate Error");
        alertDialog.setMessage(message);
        alertDialog.setButton(DialogInterface.BUTTON_POSITIVE, "OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                // Ignore SSL certificate errors
                handler.proceed();
            }
        });

        alertDialog.setButton(DialogInterface.BUTTON_NEGATIVE, "Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                handler.cancel();
            }
        });
        alertDialog.show();*/
    //}
//}
/*
// SSL Error Tolerant Web View Client
public class SSLTolerentWebViewClient extends WebViewClient {

    @Override
    public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
        handler.proceed(); // Ignore SSL certificate errors
    }

}*/