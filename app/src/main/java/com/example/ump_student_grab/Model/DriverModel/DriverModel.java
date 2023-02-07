package com.example.ump_student_grab.Model.DriverModel;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.example.ump_student_grab.Controller.Customer.BookingDetail;
import com.example.ump_student_grab.Controller.Driver.DriverProfile;
import com.example.ump_student_grab.Main;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.HashMap;
import java.util.Map;


public class DriverModel {

    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    StorageReference storageReference;
    FirebaseUser user;
    private Context context;

    public DriverModel(Context context) {
        this.context = context;
    }

    public void uploadImageFirebase (Uri imageUri) {

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();
        user = fAuth.getCurrentUser();

        //Uplod image to firebase storage
        StorageReference storeRef = storageReference.child("profile.jpg");
        storeRef.putFile(imageUri).addOnSuccessListener(new OnSuccessListener<UploadTask.TaskSnapshot>() {
            @Override
            public void onSuccess(UploadTask.TaskSnapshot taskSnapshot) {
                Toast.makeText(context, "Image uploaded successfully", Toast.LENGTH_SHORT).show();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(context, "Failed", Toast.LENGTH_SHORT).show();
            }
        });
    }

    public void updateDriverDetail (String name, String phone, String license, String car, String plate) {

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();
        user = fAuth.getCurrentUser();

        DocumentReference df = fStore.collection("Users").document(user.getUid());
        Map<String, Object> driverInfo = new HashMap<>();
        driverInfo.put("Name", name);
        driverInfo.put("phone", phone);
        driverInfo.put("LicenseNo", license);
        driverInfo.put("CarBrand", car);
        driverInfo.put("PlateNo", plate);
        df.update(driverInfo).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                Toast.makeText(context, "Profile Updated", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(context, DriverProfile.class);
                context.startActivity(intent);
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(context, "Book Failed", Toast.LENGTH_SHORT).show();
            }
        });
    }

}
