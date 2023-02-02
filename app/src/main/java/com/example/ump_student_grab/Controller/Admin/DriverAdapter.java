package com.example.ump_student_grab.Controller.Admin;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.example.ump_student_grab.Controller.Driver.PassengerAdapter;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.firebase.firestore.DocumentSnapshot;

public class DriverAdapter extends FirestoreRecyclerAdapter<Driver, DriverAdapter.DriverHolder> {

    private onItemClickListener listener;

    public DriverAdapter(@NonNull FirestoreRecyclerOptions<Driver> options) {
        super(options);
    }

    @Override
    protected void onBindViewHolder(@NonNull DriverHolder holder, int position, @NonNull Driver model) {
        holder.dName.setText(model.getName());
        holder.dPhone.setText(model.getphone());
        holder.dLicense_No.setText(model.getLicenseNo());
        holder.dCar_Brand.setText(model.getCarBrand());
        holder.dPlate_No.setText(model.getPlateNo());

    }

    @NonNull
    @Override
    public DriverHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.driver_row, parent, false);
        return new DriverHolder(view);
    }

    class DriverHolder extends RecyclerView.ViewHolder {

        TextView dName, dPhone, dLicense_No, dCar_Brand,dPlate_No;

        public DriverHolder(@NonNull View itemView) {
            super(itemView);

            dName = itemView.findViewById(R.id.driverName);
            dPhone = itemView.findViewById(R.id.driverPhone);
            dLicense_No = itemView.findViewById(R.id.driverLicense);
            dCar_Brand = itemView.findViewById(R.id.driverCar_Brand);
            dPlate_No = itemView.findViewById(R.id.driverPlate_No);


            //Click on item in Recyclerview
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int position = getAdapterPosition();
                    if (position != RecyclerView.NO_POSITION && listener != null) {
                        DocumentSnapshot documentSnapshot = getSnapshots().getSnapshot(position);
                        listener.onItemClick(documentSnapshot, position);
                    }
                }
            });
        }
    }

    public interface onItemClickListener {
        void onItemClick(DocumentSnapshot documentSnapshot, int position);
    }

    public void setOnItemClickListener (onItemClickListener listener) {
        this.listener = listener;
    }
}
