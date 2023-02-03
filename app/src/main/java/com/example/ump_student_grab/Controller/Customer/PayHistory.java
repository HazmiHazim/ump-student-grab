package com.example.ump_student_grab.Controller.Customer;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Model.CustomerModel.PaymentModel;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentChange;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;

public class PayHistory extends AppCompatActivity {

    RecyclerView recyclerView;
    ArrayList<PaymentModel> payArrayList;
    PaymentAdapter payAdapter;
    ProgressDialog progressDialog;
    FirebaseFirestore db;
    FirebaseAuth fAuth = FirebaseAuth.getInstance();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pay_history);

        progressDialog = new ProgressDialog(PayHistory.this);
        progressDialog.setCancelable(false);
        progressDialog.setMessage("Fetching data...");
        progressDialog.show();

        recyclerView = findViewById(R.id.rvPassPayHistory);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        db = FirebaseFirestore.getInstance();
        payArrayList = new ArrayList<PaymentModel>();
        payAdapter = new PaymentAdapter(PayHistory.this, payArrayList);
        recyclerView.setAdapter(payAdapter);

        EventChangeListener();
    }

    private void EventChangeListener() {

        db.collection("Users").whereEqualTo("isCustomer", "2")
                .whereEqualTo("Status", "Paid").addSnapshotListener(new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable QuerySnapshot value, @Nullable FirebaseFirestoreException error) {

                if(error!=null) {
                    if(progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                    Log.e("Firestore error", error.getMessage());
                    return;
                }

                for(DocumentChange dc : value.getDocumentChanges()) {
                    if(dc.getType() == DocumentChange.Type.ADDED) {
                        payArrayList.add(dc.getDocument().toObject(PaymentModel.class));
                    }

                    payAdapter.notifyDataSetChanged();
                    if(progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                }
            }
        });

    }
}
