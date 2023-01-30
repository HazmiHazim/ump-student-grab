package com.example.ump_student_grab.Controller.LandingPage;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Driver.DriverProfile;
import com.example.ump_student_grab.Controller.Driver.ManagePassenger;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

public class DriverMain extends AppCompatActivity {

    ImageView driverPicture;
    TextView driverName;
    Button driverLogout, booking;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.driver_main);

        driverPicture = findViewById(R.id.view_driverPicture);
        driverName = findViewById(R.id.view_driverName);
        driverLogout = findViewById(R.id.btn_driverLogout);
        booking = findViewById(R.id.checkBooking);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();

        DocumentReference documentReference = fStore.collection("Users").document(uid);
        documentReference.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                if (documentSnapshot != null && documentSnapshot.exists()) {
                    driverName.setText(documentSnapshot.getString("Name"));
                }
            }
        });


        driverName.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverMain.this, DriverProfile.class);
                startActivity(intent);
            }
        });

        booking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverMain.this, ManagePassenger.class);
                startActivity(intent);
            }
        });

        driverLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Driver Logout
                FirebaseAuth.getInstance().signOut();
                startActivity(new Intent(getApplicationContext(), Main.class));
                finish();
            }
        });
    }
}
