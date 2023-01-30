package com.example.ump_student_grab.Controller.Customer;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.R;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.squareup.picasso.Picasso;

public class CustomerProfile extends AppCompatActivity {

    ImageView picture;
    Button edit, cancel;
    TextView viewName, viewEmail, viewMatric, viewPhone;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;
    StorageReference storageReference;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.customer_profile);

        picture = findViewById(R.id.view_picture);
        edit = findViewById(R.id.btn_edit);
        cancel = findViewById(R.id.view_cancel);
        viewName = findViewById(R.id.view_name);
        viewEmail = findViewById(R.id.view_email);
        viewMatric = findViewById(R.id.view_matric);
        viewPhone = findViewById(R.id.view_phone);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();
        storageReference = FirebaseStorage.getInstance().getReference();

        //Retrieve the data from database and set to this page
        DocumentReference documentReference = fStore.collection("Users").document(uid);
        documentReference.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                viewName.setText(documentSnapshot.getString("Name"));
                viewEmail.setText(documentSnapshot.getString("email"));
                viewMatric.setText(documentSnapshot.getString("matric"));
                viewPhone.setText(documentSnapshot.getString("phone"));
            }
        });

        //Retrieve picture from firebase and display it
        StorageReference profileRef = storageReference.child("profile.jpg");
        profileRef.getDownloadUrl().addOnSuccessListener(new OnSuccessListener<Uri>() {
            @Override
            public void onSuccess(Uri uri) {
                Picasso.get().load(uri).into(picture);
            }
        });

        edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(CustomerProfile.this, EditProfile.class);
                intent.putExtra("Name", viewName.getText().toString());
                intent.putExtra("email", viewEmail.getText().toString());
                intent.putExtra("matric", viewMatric.getText().toString());
                intent.putExtra("phone", viewPhone.getText().toString());
                startActivity(intent);
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(CustomerProfile.this, CustomerMain.class);
                startActivity(intent);
            }
        });
    }
}
