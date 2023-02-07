package com.example.ump_student_grab.Controller.Admin;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Customer.EditProfile;
import com.example.ump_student_grab.Controller.Driver.DriverProfile;
import com.example.ump_student_grab.Controller.Driver.EditDriver;
import com.example.ump_student_grab.Model.AdminModel.AdminModel;
import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.Model.DriverModel.DriverModel;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

public class EditAdmin extends AppCompatActivity {

    EditText editName, editPhone, editEmail;
    Button back, save;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    FirebaseUser user;

    //Call Admin Model Class
    AdminModel am = new AdminModel(EditAdmin.this);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_admin);

        editName = findViewById(R.id.edit_adminName);
        editPhone = findViewById(R.id.edit_adminPhone);
        editEmail = findViewById(R.id.edit_adminEmail);
        save = findViewById(R.id.btn_saveAdmin);
        back = findViewById(R.id.btn_cancelAdmin);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        user = fAuth.getCurrentUser();

        //Get data from DriverProfile Class
        Intent data = getIntent();
        String name = data.getStringExtra("Name");
        String phone = data.getStringExtra("phone");
        String email = data.getStringExtra("email");

        //Set Text to EditText
        editName.setText(name);
        editPhone.setText(phone);
        editEmail.setText(email);

        save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editName.getText().toString().isEmpty() || editPhone.getText().toString().isEmpty() || editEmail.getText().toString().isEmpty()) {
                    Toast.makeText(EditAdmin.this, "Field is empty", Toast.LENGTH_SHORT).show();
                    return;
                }
                am.updateAdminProfile(editName.getText().toString(), editPhone.getText().toString(), editEmail.getText().toString());
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(EditAdmin.this, AdminProfile.class);
                startActivity(intent);
            }
        });

    }
}
