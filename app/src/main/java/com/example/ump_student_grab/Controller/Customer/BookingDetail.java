package com.example.ump_student_grab.Controller.Customer;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;


import com.example.ump_student_grab.Controller.Driver.Passenger;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.firestore.Query;

import java.util.HashMap;
import java.util.Map;


public class BookingDetail extends AppCompatActivity {

    TextView bookFrom, bookTo, bookTime, bookDate, driverName;
    Button btn_cancelBook, btn_back, seeDriver;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    String uid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.booking_detail);

        bookFrom = findViewById(R.id.book_from);
        bookTo = findViewById(R.id.book_to);
        bookTime = findViewById(R.id.book_time);
        bookDate = findViewById(R.id.book_date);
        driverName = findViewById(R.id.view_driverName);
        seeDriver = findViewById(R.id.driverDetailBtn);
        btn_cancelBook = findViewById(R.id.book_cancel);
        btn_back = findViewById(R.id.book_back);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        uid = fAuth.getCurrentUser().getUid();


        DocumentReference documentReference = fStore.collection("Users").document(uid);
        documentReference.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                bookFrom.setText(documentSnapshot.getString("From"));
                bookTo.setText(documentSnapshot.getString("To"));
                bookTime.setText(documentSnapshot.getString("Time"));
                bookDate.setText(documentSnapshot.getString("Date"));
            }
        });

        DocumentReference df = fStore.collection("Users").document("ptXy7kL4LeZy82Xyf2Am4Kk94oG2");
        df.addSnapshotListener(this, new EventListener<DocumentSnapshot>() {
            @Override
            public void onEvent(@Nullable DocumentSnapshot documentSnapshot, @Nullable FirebaseFirestoreException error) {
                driverName.setText(documentSnapshot.getString("Name"));
            }
        });

        seeDriver.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(BookingDetail.this, DriverDetail.class);
                startActivity(intent);
            }
        });

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(BookingDetail.this, CustomerMain.class);
                startActivity(intent);
            }
        });

        btn_cancelBook.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(BookingDetail.this);
                builder.setTitle("Confirmation");
                builder.setMessage("Are you sure want to cancel booking?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        //Delete Booking
                        FirebaseUser user = fAuth.getCurrentUser();
                        DocumentReference df = fStore.collection("Users").document(uid);
                        Map<String,Object> deleteBook = new HashMap<>();
                        deleteBook.put("From", FieldValue.delete());
                        deleteBook.put("To", FieldValue.delete());
                        deleteBook.put("Time", FieldValue.delete());
                        deleteBook.put("Date", FieldValue.delete());
                        df.update(deleteBook).addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void unused) {
                                Toast.makeText(BookingDetail.this, "Cancel booking is successful", Toast.LENGTH_SHORT).show();
                                startActivity(new Intent(getApplicationContext(), CustomerMain.class));
                            }
                        }).addOnFailureListener(new OnFailureListener() {
                            @Override
                            public void onFailure(@NonNull Exception e) {
                                Toast.makeText(BookingDetail.this, "Cancel Booking Failed", Toast.LENGTH_SHORT).show();
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
        });
    }
}
