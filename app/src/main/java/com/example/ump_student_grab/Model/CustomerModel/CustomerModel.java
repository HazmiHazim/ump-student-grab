package com.example.ump_student_grab.Model.CustomerModel;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import com.example.ump_student_grab.Controller.Customer.BookingDetail;
import com.example.ump_student_grab.Controller.Customer.BookingDriver;
import com.example.ump_student_grab.Controller.Customer.ChangePassword;
import com.example.ump_student_grab.Controller.Customer.CustomerProfile;
import com.example.ump_student_grab.Controller.Customer.EditProfile;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Main;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.HashMap;
import java.util.Map;

public class CustomerModel {

    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    StorageReference storageReference;
    FirebaseUser user;
    private Context context;
    double fee = 0;

    public CustomerModel(Context context) {
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

    public void updateEmailFirebase (String email, String name, String matric, String phone) {
        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();
        user = fAuth.getCurrentUser();
        
        user.updateEmail(email).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                DocumentReference docRef = fStore.collection("Users").document(user.getUid());
                Map<String, Object> edit = new HashMap<>();
                edit.put("email", email);
                edit.put("Name", name);
                edit.put("matric", matric);
                edit.put("phone", phone);
                docRef.update(edit).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void unused) {
                        Toast.makeText(context, "Profile Updated", Toast.LENGTH_SHORT).show();
                    }
                });
                Toast.makeText(context, "Email Update Succesffuly", Toast.LENGTH_SHORT).show();
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(context, "Update Failed", Toast.LENGTH_SHORT).show();
            }
        });
    }

    public void bookDriver(String bookFrom, String bookTo, String bookTime, String bookDate, String bookStatus, int tripStatus, double amountPaid) {

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        user = fAuth.getCurrentUser();

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("Confirmation");
        builder.setMessage("Please make sure that your booking detail is true");
        builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                DocumentReference df = fStore.collection("Users").document(user.getUid());
                Map<String, Object> bookinfo = new HashMap<>();
                bookinfo.put("From", bookFrom);
                bookinfo.put("To", bookTo);
                bookinfo.put("Time", bookTime);
                bookinfo.put("Date", bookDate);
                bookinfo.put("Status",bookStatus);
                bookinfo.put("Trip Status", tripStatus);
                bookinfo.put("AmountPaid",amountPaid);
                df.update(bookinfo).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void unused) {
                        Toast.makeText(context, "Book Success", Toast.LENGTH_SHORT).show();
                        //Set fee to the customer
                        DocumentReference df = fStore.collection("Users").document(user.getUid());
                        df.get().addOnSuccessListener(new OnSuccessListener<DocumentSnapshot>() {
                            @Override
                            public void onSuccess(DocumentSnapshot documentSnapshot) {
                                if(documentSnapshot.get("From").equals("UMP") && documentSnapshot.get("To").equals("DHUAM")){
                                    fee = 7.00;
                                }
                                else if(documentSnapshot.get("From").equals("UMP") && documentSnapshot.get("To").equals("PEKAN")) {
                                    fee = 15.00;
                                }
                                else if(documentSnapshot.get("From").equals("UMP") && documentSnapshot.get("To").equals("KUANTAN")) {
                                    fee = 40.00;
                                }
                                else if(documentSnapshot.get("From").equals("DHUAM") && documentSnapshot.get("To").equals("PEKAN")) {
                                    fee = 5.00;
                                }
                                else if(documentSnapshot.get("From").equals("DHUAM") && documentSnapshot.get("To").equals("UMP")) {
                                    fee = 7.00;
                                }
                                else if(documentSnapshot.get("From").equals("DHUAM") && documentSnapshot.get("To").equals("KUANTAN")) {
                                    fee = 40.00;
                                }
                                else if(documentSnapshot.get("From").equals("PEKAN") && documentSnapshot.get("To").equals("DHUAM")) {
                                    fee = 5.00;
                                }
                                else if(documentSnapshot.get("From").equals("PEKAN") && documentSnapshot.get("To").equals("UMP")) {
                                    fee = 15.00;
                                }
                                else if(documentSnapshot.get("From").equals("PEKAN") && documentSnapshot.get("To").equals("KUANTAN")) {
                                    fee = 50.00;
                                }
                                else if(documentSnapshot.get("From").equals("KUANTAN") && documentSnapshot.get("To").equals("DHUAM")) {
                                    fee = 40.00;
                                }
                                else if(documentSnapshot.get("From").equals("KUANTAN") && documentSnapshot.get("To").equals("PEKAN")) {
                                    fee = 50.00;
                                }
                                else if(documentSnapshot.get("From").equals("KUANTAN") && documentSnapshot.get("To").equals("UMP")) {
                                    fee = 40.00;
                                }
                                Map<String, Object> bookfee = new HashMap<>();
                                bookfee.put("Fee", fee);
                                df.update(bookfee).addOnSuccessListener(new OnSuccessListener<Void>() {
                                    @Override
                                    public void onSuccess(Void unused) {
                                        //
                                    }
                                }).addOnFailureListener(new OnFailureListener() {
                                    @Override
                                    public void onFailure(@NonNull Exception e) {
                                        //
                                    }
                                });
                            }
                        }).addOnFailureListener(new OnFailureListener() {
                            @Override
                            public void onFailure(@NonNull Exception e) {
                                //
                            }
                        });
                        Intent intent = new Intent(context, BookingDetail.class);
                        context.startActivity(intent);
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Toast.makeText(context, "Book Failed", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
        builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //Nothing happen
            }
        });
        builder.create().show();
    }


    public void updatePassword (Context context, String oldPassword, String newPassword) {

        user = FirebaseAuth.getInstance().getCurrentUser();

        AuthCredential credential = EmailAuthProvider.getCredential(user.getEmail(), oldPassword);
        user.reauthenticate(credential).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void unused) {
                //Change password
                user.updatePassword(newPassword).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void unused) {
                        Toast.makeText(context, "Change Password Successful", Toast.LENGTH_SHORT).show();
                        FirebaseAuth.getInstance().signOut();
                        Intent intent = new Intent(context, Main.class);
                        context.startActivity(intent);
                    }
                }).addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Toast.makeText(context, "Change Password Failed", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(context, "Old password is incorrect", Toast.LENGTH_SHORT).show();
            }
        });
    }

}
