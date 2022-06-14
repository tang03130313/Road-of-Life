package com.bilab.lunsenluandroid;


import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Timer;
import java.util.TimerTask;

public class LoadingActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.loading);
        //Toolbar toolbar = findViewById(R.id.toolbar);
        //setSupportActionBar(toolbar);

       /*try{
            // delay 1 second
            Thread.sleep(3000);
            Intent intent = new Intent();
            intent.setClass(LoadingActivity.this, LoginActivity.class);
            startActivity(intent);
        } catch(InterruptedException e){
            e.printStackTrace();

        }*/
        final Intent localIntent = new Intent(this, LoginActivity.class);
        Timer timer = new Timer();
        TimerTask tast = new TimerTask() {
            @Override
            public void run() {
                startActivity(localIntent);
                finish();
            }
        };
        timer.schedule(tast, 2000);


    }
}
