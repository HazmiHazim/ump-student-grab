package com.example.ump_student_grab.Controller.Admin;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Controller.LandingPage.AdminMain;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

import java.util.HashMap;
import java.util.Map;

public class RegisteredDriver extends AppCompatActivity {

    FirebaseFirestore fStore = FirebaseFirestore.getInstance();
    FirebaseAuth fAuth = FirebaseAuth.getInstance();
    CollectionReference driverRef = fStore.collection("Users");
    DriverAdapter dAdapter;
    TextView totalRegistered;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.registered_driver);

        totalRegistered = findViewById(R.id.total_approve);

        driverRef.whereEqualTo("isApprove", "Yes").get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                int count = task.getResult().size();
                totalRegistered.setText(String.valueOf(count));
                Log.d("TAG", "Count: " + count);
            } else {
                Log.d("TAG", "Count failed: ", task.getException());
            }
        });

        setRecyclerView();

        dAdapter.setOnItemClickListener(new DriverAdapter.onItemClickListener() {
            @Override
            public void onItemClick(DocumentSnapshot documentSnapshot, int position) {
                AlertDialog.Builder builder = new AlertDialog.Builder(RegisteredDriver.this);
                builder.setTitle("Confirmation");
                builder.setMessage("Are you sure want to delete this driver?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String driverUID = documentSnapshot.getId();

                        DocumentReference df = fStore.collection("Users").document(driverUID);
                        df.delete();
                        Toast.makeText(RegisteredDriver.this, "Driver is Deleted", Toast.LENGTH_SHORT).show();
                        //Intent page
                        //Intent intent = new Intent(AdminMain.this, PickupPassenger.class);
                        //startActivity(intent);
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

    private void setRecyclerView() {

        Query query = driverRef.orderBy("isDriver").orderBy("isApprove");

        FirestoreRecyclerOptions<Driver> options = new FirestoreRecyclerOptions.Builder<Driver>().setQuery(query, Driver.class).build();

        dAdapter = new DriverAdapter(options);

        RecyclerView recyclerView = findViewById(R.id.registered_driver_list);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(dAdapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        dAdapter.startListening();
    }

    @Override
    protected void onStop() {
        super.onStop();
        dAdapter.stopListening();
    }
}
