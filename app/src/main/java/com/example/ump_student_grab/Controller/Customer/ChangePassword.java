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
import com.example.ump_student_grab.Controller.LandingPage.AdminMain;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

public class ChangePassword extends AppCompatActivity {

    EditText oldPassword, newPassword, confirmPassword;
    Button btnSave, btnHome;
    FirebaseUser user;
    CustomerModel cm;
    boolean valid = true;
    FirebaseFirestore fStore;
    FirebaseAuth fAuth;

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
                    if(!oldPassword.getText().toString().equals(newPassword.getText().toString())) {
                        if (newPassword.getText().toString().equals(confirmPassword.getText().toString())) {
                            CustomerModel cm = new CustomerModel(ChangePassword.this);
                            cm.updatePassword(ChangePassword.this, oldPassword.getText().toString(), newPassword.getText().toString());
                        } else {
                            Toast.makeText(ChangePassword.this, "New Password and Confirm Password Must Be Identical", Toast.LENGTH_SHORT).show();
                        }
                    }
                    else
                        Toast.makeText(ChangePassword.this, "Old password and new password must be different", Toast.LENGTH_SHORT).show();
                }
            }
        });

        btnHome.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                fAuth = FirebaseAuth.getInstance();
                fStore = FirebaseFirestore.getInstance();
                user = fAuth.getCurrentUser();

                DocumentReference df = fStore.collection("Users").document(user.getUid());
                df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                    @Override
                    public void onSuccess(DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists() && documentSnapshot.get("isAdmin") != null && documentSnapshot.get("isAdmin").equals("1")) {
                            Intent intent = new Intent(ChangePassword.this, AdminMain.class);
                            startActivity(intent);
                        } else if (documentSnapshot.exists() && documentSnapshot.get("isCustomer") != null && documentSnapshot.get("isCustomer").equals("2")) {
                            Intent intent = new Intent(ChangePassword.this, CustomerMain.class);
                            startActivity(intent);
                        } else if (documentSnapshot.exists() && documentSnapshot.get("isDriver") != null && documentSnapshot.get("isDriver").equals("3")) {
                            Intent intent = new Intent(ChangePassword.this, DriverMain.class);
                            startActivity(intent);
                        }
                    }
                });

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
