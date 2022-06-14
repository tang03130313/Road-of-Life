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

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bilab.lunsenluandroid.HealthPassActivity;
import com.bilab.lunsenluandroid.R;
import com.bilab.lunsenluandroid.model.HPData;
//import com.bumptech.glide.Glide;
import com.wang.avi.AVLoadingIndicatorView;

import java.util.ArrayList;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

import static android.content.Context.MODE_PRIVATE;

public class RecycleViewHealthPass extends RecyclerView.Adapter<RecycleViewHealthPass.ViewHolder>{
    private static final String TAG = "RecyclerViewAdapter";

    private ArrayList<String> mImageNames = new ArrayList<>();
    private ArrayList<String> mDetails = new ArrayList<>();
    private ArrayList<String> mImages = new ArrayList<>();

    private List<HPData> List;

    private Context mContext;

    public RecycleViewHealthPass(Context context, List<HPData> allData) {
        this.mContext = context;
        List = allData;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_listitem_2, parent, false);
        RecycleViewHealthPass.ViewHolder holder = new RecycleViewHealthPass.ViewHolder(view);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        Log.d(TAG, "onBindViewHolder: called.");
        final HPData data = List.get(position);


        holder.name.setText(data.getTime());
        holder.detail.setText(data.getDetail()+" 個疾病資料");
        if(!data.getEdit()) {
            holder.delete.setVisibility(View.GONE);
            if(data.getState() == 0) {
                holder.checked.setVisibility(View.VISIBLE);
                holder.unchecked.setVisibility(View.GONE);
                holder.loading.setVisibility(View.GONE);
            }
            else if (data.getState() == 1){
                holder.unchecked.setVisibility(View.VISIBLE);
                holder.checked.setVisibility(View.GONE);
                holder.loading.setVisibility(View.GONE);
            }
            else{
                holder.loading.setVisibility(View.VISIBLE);
                holder.unchecked.setVisibility(View.GONE);
                holder.checked.setVisibility(View.GONE);
                holder.loading.smoothToShow();
                holder.detail.setText(data.getDetail());
            }
        }
        else {
            if(data.getState() != 2) holder.delete.setVisibility(View.VISIBLE);
            holder.checked.setVisibility(View.GONE);
            holder.unchecked.setVisibility(View.GONE);
            holder.loading.setVisibility(View.GONE);
        }
        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteData(position);
            }
        });
        holder.unchecked.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SharedPreferences sh = mContext.getSharedPreferences("RoadOfLifeAccount",MODE_PRIVATE);
                SharedPreferences.Editor myEdit = sh.edit();
                myEdit.putString("selected", String.valueOf(position+1));
                myEdit.commit();
                Log.v("position",String.valueOf(position+1));
                HealthPassActivity.notifyAdapter_2(position+1);
            }
        });
    }

    @Override
    public int getItemCount() {
        return List.size();
    }


    public class ViewHolder extends RecyclerView.ViewHolder{

        CircleImageView delete,checked,unchecked;
        AVLoadingIndicatorView loading;
        TextView name;
        TextView detail;

        public ViewHolder(View itemView) {
            super(itemView);
            name = itemView.findViewById(R.id.image_name);
            detail = itemView.findViewById(R.id.image_detail);
            delete = itemView.findViewById(R.id.delete);
            checked = itemView.findViewById(R.id.health_pass_radio_checked);
            unchecked = itemView.findViewById(R.id.health_pass_radio_unchecked);
            loading = itemView.findViewById(R.id.health_pass_radio_avi);
        }
    }


    private  void deleteData(int position){
        //databaseHelper.deleteData(List.get(position));
        AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
        dialog.setTitle("刪除確定訊息");
        dialog.setMessage("確定要刪除對"+List.get(position).getTime()+" "+List.get(position).getDetail()+"的健康存摺？");
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
                HealthPassActivity.notifyAdapter(position);
            }

        });
        dialog.show();

    }
}
