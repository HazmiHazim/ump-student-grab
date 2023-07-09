package com.example.ump_student_grab.Controller.Customer;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import com.example.ump_student_grab.Model.CustomerModel.PaymentModel;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

public class PaymentHistory extends AppCompatActivity {

    private FirebaseFirestore db = FirebaseFirestore.getInstance();
    private CollectionReference paymentRef = db.collection("Users");
    private PaymentAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pay_history);
        
        setUpRecyclerView();
    }

    private void setUpRecyclerView() {

        Query query = paymentRef.whereEqualTo("isUser", 2).whereEqualTo("Status", "Paid");

        FirestoreRecyclerOptions<PaymentModel> options = new FirestoreRecyclerOptions.Builder<PaymentModel>()
                .setQuery(query,PaymentModel.class)
                .build();

        adapter = new PaymentAdapter(options);

        RecyclerView recyclerView = findViewById(R.id.rvPassPayHistory);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        adapter.startListening();
    }

    @Override
    protected void onStop() {
        super.onStop();
        adapter.stopListening();
    }
}