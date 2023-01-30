package com.example.ump_student_grab.Controller.Driver;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class PickupPassenger extends AppCompatActivity {

    private static final String TAG = "TAG";
    TextView textStatus;
    Button drop, home, mapBtn;
    boolean status = false;
    FirebaseFirestore fStore = FirebaseFirestore.getInstance();
    FirebaseAuth fAuth;
    String uid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pickup_passenger);

        textStatus = findViewById(R.id.pickupText);
        drop = findViewById(R.id.btn_drop);
        home = findViewById(R.id.btn_home);
        mapBtn = findViewById(R.id.btn_map);

        fAuth = FirebaseAuth.getInstance();
        uid = fAuth.getCurrentUser().getUid();

        drop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                status = true;
                textStatus.setText("Passenger Dropped");
                DocumentReference df = fStore.collection("Users").document(uid);
                Map<String,Object> deleteTake = new HashMap<>();
                deleteTake.put("Take", FieldValue.delete());
                df.update(deleteTake).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void unused) {
                        Toast.makeText(PickupPassenger.this, "Thank You! :)", Toast.LENGTH_SHORT).show();
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        //
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
                Uri IntentUri = Uri.parse("google.navigation:q=3.8168, 103.3317");
                Intent intent = new Intent(Intent.ACTION_VIEW, IntentUri);
                startActivity(intent);
            }
        });
    }
}
