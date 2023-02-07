package com.example.ump_student_grab.Controller.LandingPage;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupMenu;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Customer.ChangePassword;
import com.example.ump_student_grab.Controller.Customer.CustomerProfile;
import com.example.ump_student_grab.Controller.Driver.DriverProfile;
import com.example.ump_student_grab.Controller.Driver.ManagePassenger;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

public class DriverMain extends AppCompatActivity {

    ImageView driverPicture, menu;
    TextView driverName;
    Button booking;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.driver_main);

        driverPicture = findViewById(R.id.view_driverPicture);
        driverName = findViewById(R.id.view_driverName);
        booking = findViewById(R.id.checkBooking);
        menu = findViewById(R.id.driver_btn_menu);

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

        menu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PopupMenu menu = new PopupMenu(DriverMain.this, v);
                menu.getMenuInflater().inflate(R.menu.driver_main_menu, menu.getMenu());
                menu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        if (item.getItemId() == R.id.driver_profile) {
                            Intent intent = new Intent(DriverMain.this, DriverProfile.class);
                            startActivity(intent);
                        }
                        if (item.getItemId() == R.id.change_password) {
                            Intent intent = new Intent(DriverMain.this, ChangePassword.class);
                            startActivity(intent);
                        }
                        if (item.getItemId() == R.id.logout) {
                            //logout
                            FirebaseAuth.getInstance().signOut();
                            startActivity(new Intent(getApplicationContext(), Main.class));
                            finish();
                        }
                        return true;
                    }
                });
                menu.show();
            }
        });


        booking.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DriverMain.this, ManagePassenger.class);
                startActivity(intent);
            }
        });

    }
}
