package com.example.ump_student_grab.Controller.Driver;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Model.DriverModel.DriverModel;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.StorageReference;
import com.squareup.picasso.Picasso;

public class EditDriver extends AppCompatActivity {

    ImageView editDriverPicture;
    EditText driverName, driverPhone, driverLicense, driverCar, driverCarPlate;
    Button btn_cancel, btn_save;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    FirebaseUser user;

    //Call Driver Model Class
    DriverModel dm = new DriverModel(EditDriver.this);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_driver);

        editDriverPicture = findViewById(R.id.edit_driverPicture);
        driverName = findViewById(R.id.edit_driverName);
        driverPhone = findViewById(R.id.edit_driverPhone);
        driverLicense = findViewById(R.id.edit_driverLicense);
        driverCar = findViewById(R.id.edit_driverCar);
        driverCarPlate = findViewById(R.id.edit_driverPlate);
        btn_save = findViewById(R.id.btn_saveDriver);
        btn_cancel = findViewById(R.id.btn_cancelDriver);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        user = fAuth.getCurrentUser();

        //Get data from DriverProfile Class
        Intent data = getIntent();
        String name = data.getStringExtra("Name");
        String phone = data.getStringExtra("phone");
        String license = data.getStringExtra("License No");
        String car = data.getStringExtra("Car Brand");
        String plate = data.getStringExtra("Plate No");

        //Set Text to EditText
        driverName.setText(name);
        driverPhone.setText(phone);
        driverLicense.setText(license);
        driverCar.setText(car);
        driverCarPlate.setText(plate);


        editDriverPicture.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Open gallery phone
                Intent openGallery = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(openGallery, 1000);
            }
        });

        btn_save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(driverName.getText().toString().isEmpty() || driverPhone.getText().toString().isEmpty() || driverLicense.getText().toString().isEmpty() ||
                        driverCar.getText().toString().isEmpty() || driverCarPlate.getText().toString().isEmpty()) {
                    Toast.makeText(EditDriver.this, "Field is empty", Toast.LENGTH_SHORT).show();
                    return;
                }
                dm.updateDriverDetail(driverName.getText().toString(), driverPhone.getText().toString(), driverLicense.getText().toString(),
                        driverCar.getText().toString(), driverCarPlate.getText().toString());
                startActivity(new Intent(getApplicationContext(), DriverProfile.class));
                finish();
            }
        });

        btn_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(EditDriver.this, DriverProfile.class);
                startActivity(intent);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == 1000) {
            if(resultCode == Activity.RESULT_OK) {
                Uri imageUri = data.getData();
                editDriverPicture.setImageURI(imageUri);
                dm.uploadImageFirebase(imageUri);
            }
        }
    }
}
