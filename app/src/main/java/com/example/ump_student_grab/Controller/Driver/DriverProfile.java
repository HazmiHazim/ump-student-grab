package com.example.ump_student_grab.Controller.Driver;

import android.content.Intent;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Customer.CustomerProfile;
import com.example.ump_student_grab.Controller.Customer.EditProfile;
import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

public class DriverProfile extends AppCompatActivity {

    public static final String TAG = "TAG";
    ImageView driverPicture;
    TextView driverName, driverPhone, driverLicense, driverCar, carPlate;
    Button btn_back, btnEditDriver;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.driver_profile);

        driverPicture = findViewById(R.id.viewPictureDriver);
        driverName = findViewById(R.id.DriverName);
        driverPhone = findViewById(R.id.driverPhone);
        driverLicense = findViewById(R.id.driverLicence);
        driverCar = findViewById(R.id.driverCar);
        carPlate = findViewById(R.id.driverCarPlate);
        btn_back = findViewById(R.id.btn_back);
        btnEditDriver = findViewById(R.id.driver_edit);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();

        //Retrieve the data from database and set to this page
        DocumentReference documentReference = fStore.collection("Users").document(uid);
        documentReference.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                driverName.setText(documentSnapshot.getString("Name"));
                driverPhone.setText(documentSnapshot.getString("phone"));
                driverLicense.setText(documentSnapshot.getString("License No"));
                driverCar.setText(documentSnapshot.getString("Car Brand"));
                carPlate.setText(documentSnapshot.getString("Plate No"));

                Log.d(TAG, "onCreate" + driverName);
            }
        });

        btnEditDriver.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverProfile.this, EditDriver.class);
                intent.putExtra("Name", driverName.getText().toString());
                intent.putExtra("phone", driverPhone.getText().toString());
                intent.putExtra("License No", driverLicense.getText().toString());
                intent.putExtra("Car Brand", driverCar.getText().toString());
                intent.putExtra("Plate No", carPlate.getText().toString());
                startActivity(intent);
            }
        });

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverProfile.this, DriverMain.class);
                startActivity(intent);
            }
        });

    }
}
