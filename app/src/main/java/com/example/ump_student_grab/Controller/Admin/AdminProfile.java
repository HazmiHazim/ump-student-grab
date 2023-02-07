package com.example.ump_student_grab.Controller.Admin;

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
import com.example.ump_student_grab.Controller.Driver.EditDriver;
import com.example.ump_student_grab.Controller.LandingPage.AdminMain;
import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

public class AdminProfile extends AppCompatActivity {

    public static final String TAG = "TAG";
    TextView adminName, adminPhone, adminEmail;
    Button btn_back, btnEditAdmin;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.admin_profile);

        adminName = findViewById(R.id.adminName);
        adminPhone = findViewById(R.id.adminPhone);
        adminEmail = findViewById(R.id.adminEmail);
        btnEditAdmin = findViewById(R.id.admin_edit);
        btn_back = findViewById(R.id.btn_adminBack);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();

        //Retrieve the data from database and set to this page
        DocumentReference documentReference = fStore.collection("Users").document(uid);
        documentReference.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                adminName.setText(documentSnapshot.getString("Name"));
                adminPhone.setText(documentSnapshot.getString("phone"));
                adminEmail.setText(documentSnapshot.getString("email"));

                //Log.d(TAG, "onCreate" + driverName);
            }
        });

        btnEditAdmin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(AdminProfile.this, EditAdmin.class);
                intent.putExtra("Name", adminName.getText().toString());
                intent.putExtra("phone", adminPhone.getText().toString());
                intent.putExtra("email", adminEmail.getText().toString());
                startActivity(intent);
            }
        });

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(AdminProfile.this, AdminMain.class);
                startActivity(intent);
            }
        });

    }
}
