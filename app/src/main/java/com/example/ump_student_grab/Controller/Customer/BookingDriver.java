package com.example.ump_student_grab.Controller.Customer;

import android.content.Intent;
import android.os.Bundle;

import android.view.LayoutInflater;
import android.view.View;

import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Driver.ManagePassenger;
import com.example.ump_student_grab.Controller.LandingPage.CustomerMain;
import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.R;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;

import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

import java.util.HashMap;
import java.util.Map;


public class BookingDriver extends AppCompatActivity {

    public static final String TAG = "TAG";
    Button cancel, book;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    StorageReference storageReference;
    FirebaseUser user;


    String[] item1 = {"UMP", "DHUAM", "PEKAN", "KUANTAN"};
    String[] item2 = {"DHUAM", "PEKAN", "UMP", "KUANTAN"};
    String[] item3 = {"7:00 A.M", "8:00 A.M", "9:00 A.M", "10:00 A.M", "11:00 A.M", "12:00 P.M", "13:00 P.M", "14:00 P.M", "15:00 P.M", "16:00 P.M",
            "17:00 P.M", "18:00 P.M", "19:00 P.M", "20:00 P.M", "21:00 P.M", "22:00 P.M", "23:00 P.M", "00:00 A.M"};
    String[] item4 = {"SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"};

    AutoCompleteTextView autoCompleteTextView1;
    AutoCompleteTextView autoCompleteTextView2;
    AutoCompleteTextView autoCompleteTextView3;
    AutoCompleteTextView autoCompleteTextView4;

    ArrayAdapter<String> addapteritem1;
    ArrayAdapter<String> addapteritem2;
    ArrayAdapter<String> addapteritem3;
    ArrayAdapter<String> addapteritem4;

    //Call Customer Model Class
    CustomerModel cm = new CustomerModel(BookingDriver.this);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.booking_driver);

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        storageReference = FirebaseStorage.getInstance().getReference();

        autoCompleteTextView1 = findViewById(R.id.boxText1);
        autoCompleteTextView2 = findViewById(R.id.boxText2);
        autoCompleteTextView3 = findViewById(R.id.boxText3);
        autoCompleteTextView4 = findViewById(R.id.boxText4);



        //Box1
        addapteritem1 = new ArrayAdapter<String>(this, R.layout.dropdown_item, item1);
        autoCompleteTextView1.setAdapter(addapteritem1);
        autoCompleteTextView1.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                adapterView.getItemAtPosition(i).toString();
            }
        });

        //Box2
        addapteritem2 = new ArrayAdapter<String>(this, R.layout.dropdown_item, item2);
        autoCompleteTextView2.setAdapter(addapteritem2);
        autoCompleteTextView2.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                adapterView.getItemAtPosition(i).toString();
            }
        });

        //Box3
        addapteritem3 = new ArrayAdapter<String>(this, R.layout.dropdown_item, item3);
        autoCompleteTextView3.setAdapter(addapteritem3);
        autoCompleteTextView3.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                adapterView.getItemAtPosition(i).toString();
            }
        });

        //Box4
        addapteritem4 = new ArrayAdapter<String>(this, R.layout.dropdown_item, item4);
        autoCompleteTextView4.setAdapter(addapteritem4);
        autoCompleteTextView4.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                adapterView.getItemAtPosition(i).toString();
            }
        });

        cancel = findViewById(R.id.cancel_book);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(BookingDriver.this, CustomerMain.class);
                startActivity(intent);
            }
        });

        book = findViewById(R.id.book_now);
        book.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String bookStatus = "Pending";
                double amountPaid = 0.0;
                fAuth = FirebaseAuth.getInstance();
                fStore = FirebaseFirestore.getInstance();
                user = fAuth.getCurrentUser();
                cm.bookDriver(autoCompleteTextView1.getText().toString(), autoCompleteTextView2.getText().toString(),
                        autoCompleteTextView3.getText().toString(), autoCompleteTextView4.getText().toString(), bookStatus, amountPaid);
            }
        });
    }

}
