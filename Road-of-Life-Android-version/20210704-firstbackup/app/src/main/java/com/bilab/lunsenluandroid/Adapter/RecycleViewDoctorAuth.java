package com.bilab.lunsenluandroid.Adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.bilab.lunsenluandroid.DoctorAuthActivity;
import com.bilab.lunsenluandroid.R;
import com.bilab.lunsenluandroid.model.DAData;
//import com.bumptech.glide.Glide;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import de.hdodenhof.circleimageview.CircleImageView;

public class RecycleViewDoctorAuth extends RecyclerView.Adapter<RecycleViewDoctorAuth.ViewHolder>{
    private static final String TAG = "RecyclerViewAdapter";

    private ArrayList<String> mImageNames = new ArrayList<>();
    private ArrayList<String> mDetails = new ArrayList<>();
    private ArrayList<String> mImages = new ArrayList<>();

    private List<DAData> List;

    private Context mContext;

    public RecycleViewDoctorAuth(Context context, List<DAData> allData) {
        this.mContext = context;
        List = allData;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_listitem, parent, false);
        RecycleViewDoctorAuth.ViewHolder holder = new RecycleViewDoctorAuth.ViewHolder(view);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        Log.d(TAG, "onBindViewHolder: called.");
        final DAData data = List.get(position);
        /*Glide.with(mContext)
                .asBitmap()
                .load(data.getImage())
                .into(holder.image);*/


        holder.name.setText(data.getName()+" 醫生");
        holder.detail.setText(data.getHospital()+" "+data.getDepartment());
        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteData(position);
                Log.v("position",String.valueOf(position) );
            }
        });
        /*holder.parentLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d(TAG, "onClick: clicked on: " + mImageNames.get(position));

                Toast.makeText(mContext, mImageNames.get(position), Toast.LENGTH_SHORT).show();
            }
        });*/
    }

    @Override
    public int getItemCount() {
        return List.size();
    }


    public class ViewHolder extends RecyclerView.ViewHolder{

        CircleImageView image,delete;
        TextView name;
        TextView detail;
        RelativeLayout parentLayout;

        public ViewHolder(View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.image);
            name = itemView.findViewById(R.id.image_name);
            detail = itemView.findViewById(R.id.image_detail);
            parentLayout = itemView.findViewById(R.id.parent_layout);
            delete = itemView.findViewById(R.id.delete);
        }
    }


    private  void deleteData(int position){
        //databaseHelper.deleteData(List.get(position));
        AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
        dialog.setTitle("刪除確定訊息");
        dialog.setMessage("確定要刪除對"+List.get(position).getHospital()+" "+List.get(position).getDepartment()+" "+List.get(position).getName()+"的授權？");
        dialog.setNegativeButton("取消",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface arg0, int arg1) {
                // TODO Auto-generated method stub
            }

        });
        dialog.setPositiveButton("確定",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface arg0, int arg1) {
                // TODO Auto-generated method stub
                List.remove(position);
                DoctorAuthActivity.notifyAdapter(position);
            }

        });
        dialog.show();

    }
}
