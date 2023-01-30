package com.example.ump_student_grab.Controller.Customer;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

public class DriverDetail extends AppCompatActivity {

    ImageView driverDetailPicture;
    TextView driverDetailName, driverDetailPhone, driverDetailLicense, driverDetailCar, driverCarPlate;
    Button btn_back, btn_chat;
    FirebaseFirestore fStore;
    DocumentReference df = fStore.collection("Users").document("ptXy7kL4LeZy82Xyf2Am4Kk94oG2");

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.driver_detail);

        driverDetailPicture = findViewById(R.id.driver_seePicture);
        driverDetailName = findViewById(R.id.driver_seeName);
        driverDetailPhone = findViewById(R.id.driver_seePhone);
        driverDetailLicense = findViewById(R.id.driver_seeLisence);
        driverDetailCar = findViewById(R.id.driver_seeCar);
        driverCarPlate = findViewById(R.id.driver_seePlate);
        btn_back = findViewById(R.id.view_driverBack);
        btn_chat = findViewById(R.id.btn_chat);

        df.addSnapshotListener(new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                driverDetailName.setText(documentSnapshot.getString("Name"));
                driverDetailPhone.setText(documentSnapshot.getString("phone"));
                driverDetailPhone.setText(documentSnapshot.getString("Plate No"));
                driverDetailLicense.setText(documentSnapshot.getString("License No"));
                driverDetailCar.setText(documentSnapshot.getString("Car Brand"));
                driverCarPlate.setText(documentSnapshot.getString("Plate No"));
            }
        });

        btn_chat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverDetail.this, ChatDriver.class);
                startActivity(intent);
            }
        });

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverDetail.this, BookingDetail.class);
                startActivity(intent);
            }
        });
    }
}
