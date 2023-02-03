package com.example.ump_student_grab.Controller.Customer;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Model.CustomerModel.PaymentModel;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class PaymentAdapter extends RecyclerView.Adapter<PaymentAdapter.MyViewHolder>{

    Context context;
    ArrayList<PaymentModel> payArrayList;

    FirebaseFirestore fStore;
    FirebaseAuth fAuth;
    String uid;

    public PaymentAdapter(Context context, ArrayList<PaymentModel> payArrayList) {
        this.context = context;
        this.payArrayList = payArrayList;
    }

    @NonNull
    @Override
    public PaymentAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(context).inflate(R.layout.pay_item,parent,false);
        return new MyViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull PaymentAdapter.MyViewHolder holder, int position) {

        PaymentModel payModel = payArrayList.get(position);

        holder.From.setText(payModel.getFrom());
        holder.To.setText(payModel.getTo());
        holder.Driver.setText(payModel.getDriver());
        holder.Status.setText(payModel.getStatus());
        holder.amountPaid.setText(String.valueOf(payModel.getAmountPaid()));

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();

        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                AlertDialog.Builder builder = new AlertDialog.Builder(v.getContext());
                builder.setTitle("Confirmation");
                builder.setMessage("Delete payment history?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {

                    FirebaseUser user = fAuth.getCurrentUser();
                    DocumentReference df = fStore.collection("Users").document(uid);
                    public void onClick(DialogInterface dialog, int which) {

                        // delete
                        df = fStore.collection("Users").document(uid);
                        Map<String, Object> map = new HashMap<>();
                        map.put("From", FieldValue.delete());
                        map.put("To", FieldValue.delete());
                        map.put("Driver", FieldValue.delete());
                        map.put("Status", FieldValue.delete());
                        map.put("Amount Paid", FieldValue.delete());
                        df.update(map);

                        df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                            @Override
                            public void onSuccess(DocumentSnapshot documentSnapshot) {
                                Toast.makeText(context, "Delete success", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                });
                builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //Nothing happen
                    }
                });
                builder.create().show();
            }
        });
    }

    @Override
    public int getItemCount() {
        return payArrayList.size();
    }

    //refer to all element wants to populate in the recyclerview
    public static class MyViewHolder extends RecyclerView.ViewHolder {

        TextView From, To, Driver, Status, amountPaid;
        ImageView delete;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);

            From = itemView.findViewById(R.id.tvFrom);
            To = itemView.findViewById(R.id.tvTo);
            Driver = itemView.findViewById(R.id.tvDriver);
            Status = itemView.findViewById(R.id.tvStatus);
            amountPaid = itemView.findViewById(R.id.tvAmountPaid);
            delete = itemView.findViewById(R.id.delete);
        }
    }
}
