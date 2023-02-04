package com.example.ump_student_grab.Controller.Driver;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class PickupPassenger extends AppCompatActivity {

    TextView textStatus;
    Button drop, home, mapBtn;
    boolean status = false;
    FirebaseFirestore fStore;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pickup_passenger);

        textStatus = findViewById(R.id.pickupText);
        drop = findViewById(R.id.btn_drop);
        home = findViewById(R.id.btn_home);
        mapBtn = findViewById(R.id.btn_map);

        fStore = FirebaseFirestore.getInstance();

        Intent data = getIntent();
        String customerID = data.getStringExtra("id");

        drop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                status = true;
                textStatus.setText("Passenger Dropped");
                DocumentReference df = fStore.collection("Users").document(customerID);
                Map<String,Object> drop = new HashMap<>();
                drop.put("From", FieldValue.delete());
                drop.put("To", FieldValue.delete());
                drop.put("Time", FieldValue.delete());
                drop.put("Date", FieldValue.delete());
                drop.put("Driver Phone No", FieldValue.delete());
                df.update(drop).addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        Toast.makeText(PickupPassenger.this, "Thank You! :)", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });

        home.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(PickupPassenger.this, DriverMain.class);
                startActivity(intent);
            }
        });

        mapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DocumentReference df = fStore.collection("Users").document(customerID);
                df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                    @Override
                    public void onSuccess(DocumentSnapshot documentSnapshot) {
                        //From: Kuantan
                        if(documentSnapshot.get("From").equals("KUANTAN")){
                            Uri IntentUri = Uri.parse("google.navigation:q=3.8168, 103.3317");
                            Intent intent = new Intent(Intent.ACTION_VIEW, IntentUri);
                            startActivity(intent);
                        }
                        //From: PEKAN
                        if(documentSnapshot.get("From").equals("PEKAN")){
                            Uri IntentUri = Uri.parse("google.navigation:q=3.4921, 103.3895");
                            Intent intent = new Intent(Intent.ACTION_VIEW, IntentUri);
                            startActivity(intent);
                        }
                        //From: UMP
                        if(documentSnapshot.get("From").equals("UMP")){
                            Uri IntentUri = Uri.parse("google.navigation:q=3.5436, 103.4289");
                            Intent intent = new Intent(Intent.ACTION_VIEW, IntentUri);
                            startActivity(intent);
                        }
                        //From: DHUAM
                        if(documentSnapshot.get("From").equals("DHUAM")){
                            Uri IntentUri = Uri.parse("google.navigation:q=3.5306, 103.3905");
                            Intent intent = new Intent(Intent.ACTION_VIEW, IntentUri);
                            startActivity(intent);
                        }
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Toast.makeText(PickupPassenger.this, "Location Does Not Exist", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }
}
