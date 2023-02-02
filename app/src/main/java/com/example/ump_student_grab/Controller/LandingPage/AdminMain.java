package com.example.ump_student_grab.Controller.LandingPage;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Controller.Admin.Driver;
import com.example.ump_student_grab.Controller.Admin.DriverAdapter;
import com.example.ump_student_grab.Controller.Admin.RegisteredDriver;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

import java.util.HashMap;
import java.util.Map;

public class AdminMain extends AppCompatActivity {

    FirebaseFirestore fStore = FirebaseFirestore.getInstance();
    FirebaseAuth fAuth = FirebaseAuth.getInstance();
    CollectionReference driverRef = fStore.collection("Users");
    DriverAdapter dAdapter;
    Button logout, btnApprove;
    TextView totalPending;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.admin_main);

        logout = findViewById(R.id.adminLogout);
        totalPending = findViewById(R.id.total_pending);
        btnApprove = findViewById(R.id.btn_viewApproved);

        btnApprove.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(AdminMain.this, RegisteredDriver.class);
                startActivity(intent);
            }
        });

        driverRef.whereEqualTo("isPending", "0").get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                int count = task.getResult().size();
                totalPending.setText(String.valueOf(count));
                Log.d("TAG", "Count: " + count);
            } else {
                Log.d("TAG", "Count failed: ", task.getException());
            }
        });

        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FirebaseAuth.getInstance().signOut();
                Intent intent = new Intent(AdminMain.this, Main.class);
                startActivity(intent);
            }
        });

        setRecyclerView();

        dAdapter.setOnItemClickListener(new DriverAdapter.onItemClickListener() {
            @Override
            public void onItemClick(DocumentSnapshot documentSnapshot, int position) {
                AlertDialog.Builder builder = new AlertDialog.Builder(AdminMain.this);
                builder.setTitle("Confirmation");
                builder.setMessage("Are you sure want to approve this driver?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String driverUID = documentSnapshot.getId();

                        // Add the driver's name to the customer's database as the "Driver" field
                        DocumentReference driverDocRef = fStore.collection("Users").document(driverUID);
                        Map<String, Object> approve = new HashMap<>();
                        approve.put("isApprove", "Yes");
                        approve.put("isPending", FieldValue.delete());
                        driverDocRef.update(approve);
                        Toast.makeText(AdminMain.this, "Driver is Approved", Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent(AdminMain.this, RegisteredDriver.class);
                        startActivity(intent);
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

        Query query = driverRef.orderBy("isDriver").orderBy("isPending");

        FirestoreRecyclerOptions<Driver> options = new FirestoreRecyclerOptions.Builder<Driver>().setQuery(query, Driver.class).build();

        dAdapter = new DriverAdapter(options);

        RecyclerView recyclerView = findViewById(R.id.driver_pending_list);
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
