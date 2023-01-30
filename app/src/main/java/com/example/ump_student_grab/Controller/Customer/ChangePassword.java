package com.example.ump_student_grab.Controller.Customer;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Auth.Registration;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

public class ChangePassword extends AppCompatActivity {

    EditText oldPassword, newPassword, confirmPassword;
    Button btnSave, btnHome;
    FirebaseUser user;
    CustomerModel cm;
    boolean valid = true;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.change_password);

        oldPassword = findViewById(R.id.oldPassword);
        newPassword = findViewById(R.id.newPassword);
        confirmPassword = findViewById(R.id.confirmPassword);
        btnSave = findViewById(R.id.btn_savePassword);
        btnHome = findViewById(R.id.btn_passHome);

        user = FirebaseAuth.getInstance().getCurrentUser();

        btnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkField(oldPassword);
                checkField(newPassword);
                checkField(confirmPassword);
                if(valid){
                    if (newPassword.getText().toString().equals(confirmPassword.getText().toString())) {
                        cm.updatePassword(oldPassword.getText().toString(), newPassword.getText().toString());
                    }
                    else {
                        Toast.makeText(ChangePassword.this, "New Password and Confirm Password Must Be Identical", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });

        btnHome.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ChangePassword.this, CustomerMain.class);
                startActivity(intent);
            }
        });
    }

    public boolean checkField (EditText textField) {
        if(textField.getText().toString().isEmpty()){
            textField.setError("Error !");
            valid = false;
        }
        else {
            valid = true;
        }
        return valid;
    }
}
