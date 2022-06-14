package com.bilab.lunsenluandroid.ui.setting;

import android.content.Context;
import android.content.Intent;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
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
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.bilab.lunsenluandroid.AccountPasswordActivity;
import com.bilab.lunsenluandroid.DoctorAuthActivity;
import com.bilab.lunsenluandroid.HealthPassActivity;
import com.bilab.lunsenluandroid.LoginActivity;
import com.bilab.lunsenluandroid.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.HashMap;

public class SettingFragment extends Fragment {
    LinearLayout health_passport,doctor_auth,info,account,private_policy;

    TextView logout;
    ImageView test;


    private SettingViewModel settingViewModel;

    Intent intent;

    String email;



    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        settingViewModel =
                ViewModelProviders.of(this).get(SettingViewModel.class);
        View root = inflater.inflate(R.layout.fragment_setting, container, false);
        /*final TextView textView = root.findViewById(R.id.text_notifications);
        settingViewModel.getText().observe(this, new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });*/
        intent = getActivity().getIntent();
        email = (intent != null ) ? intent.getStringExtra("email") : "";

        health_passport = root.findViewById(R.id.setting_health_passport);
        doctor_auth = root.findViewById(R.id.setting_doctor_auth);
        info = root.findViewById(R.id.setting_info);
        account = root.findViewById(R.id.setting_account);
        private_policy = root.findViewById(R.id.setting_private_policy);
        logout = root.findViewById(R.id.setting_log_out);
        test = root.findViewById(R.id.setting_health_passport_right);





        health_passport.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity(), HealthPassActivity.class);
                startActivity(intent);
            }
        });
        doctor_auth.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity(), DoctorAuthActivity.class);
                startActivity(intent);
            }
        });

        info.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //asd.setText("123456789");
            }
        });

        account.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClass(getActivity(), AccountPasswordActivity.class);
                startActivity(intent);
            }
        });

        private_policy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //asd.setText("123456789");
            }
        });

        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String masterKeyAlias = null,email="",password="";
                try {
                    masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
                    SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                            "RoadOfLifeAccount", masterKeyAlias, getActivity(),
                            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                    );
                    sharedPreferences.edit().clear().commit();
                } catch (GeneralSecurityException | IOException e) {
                    e.printStackTrace();
                }
                /*SharedPreferences sharedPreferences = getActivity().getSharedPreferences("RoadOfLifeAccount", Context.MODE_PRIVATE);
                SharedPreferences.Editor myEdit = sharedPreferences.edit();
                myEdit.clear();
                myEdit.commit();*/
                Intent intent = new Intent();
                intent.setClass(getActivity(), LoginActivity.class);
                startActivity(intent);
                getActivity().finish();
            }
        });

        return root;
    }

}