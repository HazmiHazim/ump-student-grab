package com.example.ump_student_grab.Controller.LandingPage;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.PopupMenu;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.Controller.Customer.BookingDetail;
import com.example.ump_student_grab.Controller.Customer.BookingDriver;
import com.example.ump_student_grab.Controller.Customer.ChangePassword;
import com.example.ump_student_grab.Controller.Customer.CustomerProfile;
import com.example.ump_student_grab.Main;
import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;

public class CustomerMain extends AppCompatActivity {

    ImageView menu;
    ImageView book;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.customer_main);

        menu = findViewById(R.id.btn_menu);
        book = findViewById(R.id.btn_book);

        menu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                PopupMenu menu = new PopupMenu(CustomerMain.this, view);
                menu.getMenuInflater().inflate(R.menu.customer_main_menu, menu.getMenu());
                menu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem menuItem) {
                        if (menuItem.getItemId() == R.id.customer_profile) {
                            Intent intent = new Intent(CustomerMain.this, CustomerProfile.class);
                            startActivity(intent);
                        }
                        if (menuItem.getItemId() == R.id.my_booking) {
                            Intent intent = new Intent(CustomerMain.this, BookingDetail.class);
                            startActivity(intent);
                        }
                        if (menuItem.getItemId() == R.id.change_password) {
                            Intent intent = new Intent(CustomerMain.this, ChangePassword.class);
                            startActivity(intent);
                        }
                        if (menuItem.getItemId() == R.id.logout) {
                            //logout
                            FirebaseAuth.getInstance().signOut();
                            startActivity(new Intent(getApplicationContext(), Main.class));
                            finish();
                        }
                        return true;
                    }
                });
                menu.show();
            }
        });

        book.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(CustomerMain.this, BookingDriver.class);
                startActivity(intent);
            }
        });
    }
}
