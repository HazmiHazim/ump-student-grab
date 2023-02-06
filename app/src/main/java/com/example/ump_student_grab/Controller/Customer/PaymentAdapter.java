package com.example.ump_student_grab.Controller.Customer;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
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
import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class PaymentAdapter extends FirestoreRecyclerAdapter<PaymentModel,PaymentAdapter.PaymentHolder> {

    Context context;
    FirebaseFirestore fStore;
    FirebaseAuth fAuth;
    String uid;

    public PaymentAdapter(@NonNull FirestoreRecyclerOptions<PaymentModel> options) {
        super(options);
    }

    @Override
    protected void onBindViewHolder(@NonNull PaymentHolder holder, int position, @NonNull PaymentModel model) {

        holder.From.setText(model.getFrom());
        holder.To.setText(model.getTo());
        holder.Driver.setText(model.getTo());
        holder.Status.setText(model.getStatus());
        holder.amountPaid.setText(String.valueOf(model.getAmountPaid()));

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

    @NonNull
    @Override
    public PaymentHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.pay_item, parent,false);
        return new PaymentHolder(v);
    }

    class PaymentHolder extends RecyclerView.ViewHolder {

        TextView From, To, Driver, Status, amountPaid;
        ImageView delete;

        public PaymentHolder(@NonNull View itemView) {
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
