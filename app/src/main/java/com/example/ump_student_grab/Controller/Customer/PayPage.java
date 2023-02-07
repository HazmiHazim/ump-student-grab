package com.example.ump_student_grab.Controller.Customer;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class PayPage extends AppCompatActivity {

    FirebaseAuth fAuth = FirebaseAuth.getInstance();
    FirebaseFirestore fStore = FirebaseFirestore.getInstance();
    EditText amount;
    Button btnConfirm;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pay_page);

        amount = findViewById(R.id.etAmountPaid);
        btnConfirm = findViewById(R.id.btnConfirm);

        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(PayPage.this);
                builder.setTitle("Confirmation");
                builder.setMessage("Do you confirm the correct amount of payment?");
                builder.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateBooking(v);
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

    public void updateBooking(View view){

        if(amount.getText().toString().isEmpty()) {
            Toast.makeText(PayPage.this, "Field is empty", Toast.LENGTH_SHORT).show();
            return;
        }

        String amt = amount.getText().toString();
        double amountPaid = Double.parseDouble(amt);

        String uid = fAuth.getCurrentUser().getUid();
        DocumentReference df = fStore.collection("Users").document(uid);

        Map<String,Object> map = new HashMap<>();
        df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
            @Override
            public void onSuccess(DocumentSnapshot documentSnapshot) {
                double fee = documentSnapshot.getDouble("Fee");
                if(amountPaid >= fee) {
                    map.put("Status","Paid");
                    map.put("AmountPaid", amountPaid);
                    df.update(map).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            Toast.makeText(PayPage.this, "Payment Received", Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(PayPage.this, PaymentHistory.class));
                        }
                    });
                }
                if(amountPaid < fee) {
                    Toast.makeText(PayPage.this, "Insufficient amount", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}
