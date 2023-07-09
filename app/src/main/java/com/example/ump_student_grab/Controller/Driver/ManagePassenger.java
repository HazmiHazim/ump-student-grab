package com.example.ump_student_grab.Controller.Driver;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Model.DriverModel.Passenger;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;

import java.util.HashMap;
import java.util.Map;


public class ManagePassenger extends AppCompatActivity {

    FirebaseFirestore fStore = FirebaseFirestore.getInstance();
    FirebaseAuth fAuth = FirebaseAuth.getInstance();
    CollectionReference passengerRef = fStore.collection("Users");
    PassengerAdapter pAdapter;
    String uid = fAuth.getCurrentUser().getUid();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.manage_passenger);

        setRecyclerView();

        pAdapter.setOnItemClickListener(new PassengerAdapter.onItemClickListener() {
            @Override
            public void onItemClick(DocumentSnapshot documentSnapshot, int position) {
                DocumentReference documentReference = fStore.collection("Users").document(uid);
                documentReference.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                    @Override
                    public void onSuccess(DocumentSnapshot ds) {
                        if (ds.contains("hasPassenger")) {
                            boolean hasPassenger = ds.getBoolean("hasPassenger");

                            if (!hasPassenger) {
                                AlertDialog.Builder builder = new AlertDialog.Builder(ManagePassenger.this);
                                builder.setTitle("Confirmation");
                                builder.setMessage("Are you sure want to pick up this passenger?");
                                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        // Put the data into Driver Firebase
                                        Map<String, Object> pickUp = new HashMap<>();
                                        pickUp.put("hasPassenger", true);
                                        documentReference.update(pickUp);

                                        // Get the customer's UID
                                        String customerUID = documentSnapshot.getId();

                                        // Get the driver's name & phone number
                                        String uid = fAuth.getCurrentUser().getUid();
                                        DocumentReference df = fStore.collection("Users").document(uid);
                                        df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                                            @Override
                                            public void onSuccess(DocumentSnapshot documentSnapshot) {
                                                String driverName = documentSnapshot.getString("Name");
                                                String driverPhoneNum = documentSnapshot.getString("phone");

                                                // Add the driver's name to the customer's database as the "Driver" field
                                                DocumentReference customerDocRef = fStore.collection("Users").document(customerUID);
                                                Map<String, Object> updates = new HashMap<>();
                                                updates.put("Driver", driverName);
                                                updates.put("Trip Status", 2);
                                                updates.put("Driver Phone No", driverPhoneNum);
                                                customerDocRef.update(updates);
                                            }
                                        });
                                        Intent intent = new Intent(ManagePassenger.this, PickupPassenger.class);
                                        intent.putExtra("id", customerUID);
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
                            else if (hasPassenger)
                                Toast.makeText(ManagePassenger.this, "You already have a passenger, cannot take more than 1 passenger at 1 time", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        });
    }

    private void setRecyclerView() {

        Query query = passengerRef.whereEqualTo("isUser", 2).whereEqualTo("Trip Status", 1);

        FirestoreRecyclerOptions<Passenger> options = new FirestoreRecyclerOptions.Builder<Passenger>().setQuery(query, Passenger.class).build();

        pAdapter = new PassengerAdapter(options);

        RecyclerView recyclerView = findViewById(R.id.passenger_list);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(pAdapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        pAdapter.startListening();
    }

    @Override
    protected void onStop() {
        super.onStop();
        pAdapter.stopListening();
    }
}
