package com.bilab.lunsenluandroid;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

public class PrivacyPolicyActivity extends AppCompatActivity {

    ImageView previous;
    Button agree,disagree;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.privacy_policy);
        getSupportActionBar().hide();

        previous =  (ImageView) findViewById(R.id.privacy_policy_previous);
        disagree =  (Button) findViewById(R.id.privacy_policy_disagree);
        agree =  (Button) findViewById(R.id.privacy_policy_agree);

        previous.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        agree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent();
                final Bundle bundle = new Bundle();
                intent.setClass(PrivacyPolicyActivity.this, RegisterActivity.class);
                startActivity(intent);
                PrivacyPolicyActivity.this.finish();
            }
        });

        disagree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }
}