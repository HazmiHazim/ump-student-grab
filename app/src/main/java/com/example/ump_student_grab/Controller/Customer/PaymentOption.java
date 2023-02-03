package com.example.ump_student_grab.Controller.Customer;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import androidx.activity.result.ActivityResultLauncher;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.ump_student_grab.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.journeyapps.barcodescanner.ScanContract;
import com.journeyapps.barcodescanner.ScanOptions;

public class PaymentOption extends AppCompatActivity {

    ImageView payCash, payQr;
    AlertDialog.Builder builder;

    FirebaseAuth fAuth = FirebaseAuth.getInstance();
    FirebaseFirestore fStore = FirebaseFirestore.getInstance();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payment_option);

        payCash = findViewById(R.id.ivCash);
        payQr = findViewById(R.id.ivQrpay);
        builder = new AlertDialog.Builder(this);

        payCash.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(PaymentOption.this, PayPage.class));
            }
        });

        payQr.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                scanCode();
//                startActivity(new Intent(PaymentOption.this, QrPay.class));
            }
        });
    }

    private void scanCode() {
        ScanOptions options = new ScanOptions();
        options.setPrompt("Volume up to flash on");
        options.setBeepEnabled(true);
        options.setOrientationLocked(true);
        options.setCaptureActivity(CaptureAct.class);
        barLaucher.launch(options);
    }

    ActivityResultLauncher<ScanOptions> barLaucher = registerForActivityResult(new ScanContract(), result->
    {
        if(result.getContents() !=null)
        {
            AlertDialog.Builder builder = new AlertDialog.Builder(PaymentOption.this);
            builder.setTitle("Result");
            builder.setMessage(result.getContents());
            builder.setPositiveButton("OK", new DialogInterface.OnClickListener()
            {
                @Override
                public void onClick(DialogInterface dialogInterface, int i)
                {
                    dialogInterface.dismiss();
                }
            }).show();
        }
    });
}
