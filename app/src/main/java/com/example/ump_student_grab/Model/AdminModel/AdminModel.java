package com.example.ump_student_grab.Model.AdminModel;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.example.ump_student_grab.Controller.Admin.AdminProfile;
import com.example.ump_student_grab.Controller.Driver.DriverProfile;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

import java.util.HashMap;
import java.util.Map;

public class AdminModel {

    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    StorageReference storageReference;
    FirebaseUser user;
    private Context context;

    public AdminModel(Context context) {
        this.context = context;
    }

    public void updateAdminProfile (String name, String phone, String email) {

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();
        user = fAuth.getCurrentUser();

        DocumentReference df = fStore.collection("Users").document(user.getUid());
        Map<String, Object> driverInfo = new HashMap<>();
        driverInfo.put("Name", name);
        driverInfo.put("phone", phone);
        driverInfo.put("email", email);
        df.update(driverInfo).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                Toast.makeText(context, "Profile Updated", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(context, AdminProfile.class);
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
