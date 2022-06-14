package com.bilab.lunsenluandroid;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import java.io.IOException;
import java.security.GeneralSecurityException;

import androidx.appcompat.app.AppCompatActivity;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKeys;

public class AccountPasswordActivity extends AppCompatActivity {

    EditText editText;
    Button button;
    ImageView password_previous;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.account_password);
        getSupportActionBar().hide();
        Intent intent = this.getIntent();
        String activity = intent.getStringExtra("activity");
        editText =  (EditText) findViewById(R.id.account_password_edit);
        button = (Button) findViewById(R.id.account_password_imageButton);
        password_previous =  findViewById(R.id.password_previous);
        password_previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String masterKeyAlias = null,password="";
                try {
                    masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
                    SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                            "RoadOfLifeAccount", masterKeyAlias, AccountPasswordActivity.this,
                            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                    );
                    password = sharedPreferences.getString("password", "");
                } catch (GeneralSecurityException | IOException e) {
                    e.printStackTrace();
                }
                /*SharedPreferences sh = getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
                String password = sh.getString("password","");*/
                if(editText.getText().toString().equals(password)){
                    Intent intent = new Intent();
                    intent.setClass(AccountPasswordActivity.this, AccountMainActivity.class);
                    if(activity!=null)
                        intent.putExtra("activity", activity);
                    startActivity(intent);
                    finish();
                }
                else
                    editText.setText("密碼錯誤");
            }
        });

    }
}
