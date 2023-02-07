package com.example.ump_student_grab;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Auth.ForgotPassword;
import com.example.ump_student_grab.Auth.Registration;
import com.example.ump_student_grab.Controller.LandingPage.AdminMain;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Controller.LandingPage.DriverMain;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

public class Main extends AppCompatActivity {

    EditText TypeEmailLogin, TypePasswordLogin;
    TextView ForgotButton, RegisterButton;
    Button btn_login;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    boolean valid = true;
    AlertDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        TypeEmailLogin = findViewById(R.id.login_email);
        TypePasswordLogin = findViewById(R.id.login_password);
        ForgotButton = findViewById(R.id.fg_button);
        RegisterButton = findViewById(R.id.reg_button);
        btn_login = findViewById(R.id.btn_login);

        //Initialize Firebase
        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();

        btn_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkField(TypeEmailLogin);
                checkField(TypePasswordLogin);
                if(valid) {
                    loadingAnim();
                    fAuth.signInWithEmailAndPassword(TypeEmailLogin.getText().toString(), TypePasswordLogin.getText().toString()).addOnSuccessListener(new OnSuccessListener<AuthResult>() {
                        @Override
                        public void onSuccess(AuthResult authResult) {
                            Toast.makeText(Main.this, "Login Successfully", Toast.LENGTH_SHORT).show();
                            checkAccessLevel(authResult.getUser().getUid());
                            //FirebaseUser user = fAuth.getCurrentUser();
                            dialog.dismiss();
                        }
                    }).addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            Toast.makeText(Main.this, e.getMessage(), Toast.LENGTH_SHORT).show();
                            dialog.dismiss();
                        }
                    });
                }
            }
        });

        ForgotButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(Main.this, ForgotPassword.class);
                startActivity(intent);
            }
        });

        RegisterButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(Main.this, Registration.class);
                startActivity(intent);
            }
        });
    }

    private void checkAccessLevel(String uid) {
        DocumentReference df = fStore.collection("Users").document(uid);
        //Extract the data from document
        df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
            @Override
            public void onSuccess(DocumentSnapshot documentSnapshot) {
                Log.d("TAG", "onSuccess: " + documentSnapshot.getData());
                //identify the user type
                if(documentSnapshot.getString("isCustomer") != null) {
                    //User is Customer
                    startActivity(new Intent(getApplicationContext(), CustomerMain.class));
                    finish();
                }
                else if(documentSnapshot.getString("isDriver") != null) {
                    //User is Driver
                    startActivity(new Intent(getApplicationContext(), DriverMain.class));
                    finish();
                }
                else {
                    //User is Admin
                    startActivity(new Intent(getApplicationContext(), AdminMain.class));
                    finish();
                }
            }
        });
    }

    public boolean checkField(EditText textField) {
        if(textField.getText().toString().isEmpty()) {
            textField.setError("Error !");
            valid = false;
        }
        else {
            valid = true;
        }
        return valid;
    }

    @Override
    protected void onStart() {
        super.onStart();
        if(FirebaseAuth.getInstance().getCurrentUser() != null){
            DocumentReference df = FirebaseFirestore.getInstance().collection("Users").document(FirebaseAuth.getInstance().getCurrentUser().getUid());
            loadingAnim();
            df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                @Override
                public void onSuccess(DocumentSnapshot documentSnapshot) {
                    if(documentSnapshot.getString("isCustomer") != null) {
                        startActivity(new Intent(getApplicationContext(), CustomerMain.class));
                        dialog.dismiss();
                        finish();
                    }
                    if(documentSnapshot.getString("isDriver") != null) {
                        startActivity(new Intent(getApplicationContext(), DriverMain.class));
                        dialog.dismiss();
                        finish();
                    }
                    if(documentSnapshot.getString("isAdmin") != null) {
                        startActivity(new Intent(getApplicationContext(), AdminMain.class));
                        dialog.dismiss();
                        finish();
                    }
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    FirebaseAuth.getInstance().signOut();
                    startActivity(new Intent(getApplicationContext(), Main.class));
                    finish();
                }
            });
        }
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
