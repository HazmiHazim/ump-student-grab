package com.example.ump_student_grab.Auth;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.LandingPage.AdminMain;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class Registration extends AppCompatActivity {

    public static final String TAG = "TAG";
    EditText TypeRegisterName, TypeRegisterMatric, TypeRegisterEmail, TypeRegisterPassword;
    Button btn_cancel, btn_register;
    CheckBox reg_customer, reg_driver, reg_admin;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    boolean valid = true;
    AlertDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register);

        TypeRegisterName = findViewById(R.id.RegisterName);
        TypeRegisterMatric = findViewById(R.id.RegisterMatric);
        TypeRegisterEmail = findViewById(R.id.RegisterEmail);
        TypeRegisterPassword = findViewById(R.id.RegisterPass);
        btn_cancel = findViewById(R.id.cancel_register);
        btn_register = findViewById(R.id.btn_register);
        reg_customer = findViewById(R.id.checkBox_customer);
        reg_driver = findViewById(R.id.checkBox_Driver);
        reg_admin = findViewById(R.id.checkBox_Admin);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();

        //If register as Customer, only customer can tick and other is cannot
        reg_customer.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(compoundButton.isChecked()) {
                    reg_driver.setChecked(false);
                }
            }
        });

        //If register as Driver, only driver can tick and other is cannot
        reg_driver.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(compoundButton.isChecked()) {
                    reg_customer.setChecked(false);
                }
            }
        });

        //If register as Amin, only driver can tick and other is cannot
        reg_admin.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(compoundButton.isChecked()) {
                    reg_driver.setChecked(false);
                    reg_customer.setChecked(false);
                }
            }
        });

        btn_register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkField(TypeRegisterName);
                checkField(TypeRegisterMatric);
                checkField(TypeRegisterEmail);
                checkField(TypeRegisterPassword);


                //CheckBox validation
                if(!(reg_customer.isChecked() || reg_driver.isChecked() || reg_admin.isChecked())) {
                    Toast.makeText(Registration.this, "Select Register as", Toast.LENGTH_SHORT).show();
                    return;
                }

                if(valid) {
                    loadingAnim();
                    //User Registration
                    fAuth.createUserWithEmailAndPassword(TypeRegisterEmail.getText().toString(), TypeRegisterPassword.getText().toString()).addOnSuccessListener(new OnSuccessListener<AuthResult>() {
                        @Override
                        public void onSuccess(AuthResult authResult) {
                            FirebaseUser user = fAuth.getCurrentUser();
                            Toast.makeText(Registration.this, "Account Registered", Toast.LENGTH_SHORT).show();
                            dialog.dismiss();
                            DocumentReference df = fStore.collection("Users").document(user.getUid());
                            Map<String, Object> userinfo = new HashMap<>();
                            userinfo.put("Name", TypeRegisterName.getText().toString());
                            userinfo.put("matric", TypeRegisterMatric.getText().toString());
                            userinfo.put("email", TypeRegisterEmail.getText().toString());

                            //Specify if the user is Customer or Driver or Admin
                            if(reg_admin.isChecked()) {
                                userinfo.put("isAdmin", "1");
                            }

                            if(reg_customer.isChecked()) {
                                userinfo.put("isCustomer", "2");
                            }
                            if(reg_driver.isChecked()) {
                                userinfo.put("isDriver", "3");
                                userinfo.put("isPending", "0");
                            }
                            df.set(userinfo);
                            if(reg_admin.isChecked()) {
                                startActivity(new Intent(getApplicationContext(), AdminMain.class));
                                finish();
                            }

                            if(reg_customer.isChecked()) {
                                startActivity(new Intent(getApplicationContext(), CustomerMain.class));
                                finish();
                            }

                            if(reg_driver.isChecked()) {
                                startActivity(new Intent(getApplicationContext(), DriverMain.class));
                                finish();
                            }
                        }
                    }).addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Toast.makeText(Registration.this, "Registration Failed", Toast.LENGTH_SHORT).show();
                            dialog.dismiss();
                        }
                    });
                }
            }
        });

        btn_cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(Registration.this, Main.class);
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

    public void loadingAnim() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        LayoutInflater inflater = this.getLayoutInflater();
        builder.setView(inflater.inflate(R.layout.load_anim, null));
        builder.setCancelable(true);
        dialog = builder.create();
        dialog.show();
    }
}
