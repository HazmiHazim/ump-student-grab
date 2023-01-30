package com.example.ump_student_grab.Controller.Customer;

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

import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.R;

import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.squareup.picasso.Picasso;


public class EditProfile extends AppCompatActivity {

    public static final String TAG = "TAG";
    ImageView picture;
    EditText TypeEditName, TypeEditEmail, TypeEditMatric, TypeEditPhone;
    Button save_button, cancel_button;
    FirebaseAuth fAuth;
    FirebaseFirestore fStroe;
    FirebaseUser user;
    StorageReference storageReference;

    //Call Customer Model Class
    CustomerModel cm = new CustomerModel(EditProfile.this);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_profile);

        //Get data from CustomerProfile Class
        Intent data = getIntent();
        String name = data.getStringExtra("Name");
        String email = data.getStringExtra("email");
        String matric = data.getStringExtra("matric");
        String phone = data.getStringExtra("phone");


        picture = findViewById(R.id.edit_picture);
        TypeEditName = findViewById(R.id.editName);
        TypeEditEmail = findViewById(R.id.editEmail);
        TypeEditMatric = findViewById(R.id.editMatric);
        TypeEditPhone = findViewById(R.id.editPhone);
        save_button = findViewById(R.id.btn_save);
        cancel_button = findViewById(R.id.edit_cancel);

        fAuth = FirebaseAuth.getInstance();
        fStroe = FirebaseFirestore.getInstance();
        user = fAuth.getCurrentUser();
        storageReference = FirebaseStorage.getInstance().getReference();

        TypeEditName.setText(name);
        TypeEditEmail.setText(email);
        TypeEditMatric.setText(matric);
        TypeEditPhone.setText(phone);

        //Retrieve email from firebase and display it
        StorageReference profileRef = storageReference.child("profile.jpg");
        profileRef.getDownloadUrl().addOnSuccessListener(new OnSuccessListener<Uri>() {
            @Override
            public void onSuccess(Uri uri) {
                Picasso.get().load(uri).into(picture);
            }
        });


        picture.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Open gallery phone
                Intent openGallery = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(openGallery, 1000);
            }
        });

        save_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(TypeEditName.getText().toString().isEmpty() || TypeEditEmail.getText().toString().isEmpty() || TypeEditPhone.getText().toString().isEmpty()) {
                    Toast.makeText(EditProfile.this, "Field is empty", Toast.LENGTH_SHORT).show();
                    return;
                }
                final String email = TypeEditEmail.getText().toString();
                cm.updateEmailFirebase(email, TypeEditName.getText().toString(),
                        TypeEditMatric.getText().toString(), TypeEditPhone.getText().toString());
                startActivity(new Intent(getApplicationContext(), CustomerProfile.class));
                finish();
            }
        });

        cancel_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(EditProfile.this, CustomerProfile.class);
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
                picture.setImageURI(imageUri);
                cm.uploadImageFirebase(imageUri);
            }
        }
    }
}
