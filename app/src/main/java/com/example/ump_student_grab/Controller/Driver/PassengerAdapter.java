package com.example.ump_student_grab.Controller.Driver;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Model.CustomerModel.CustomerModel;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;

import java.util.HashMap;
import java.util.Map;


public class PassengerAdapter extends FirestoreRecyclerAdapter<Passenger, PassengerAdapter.PassangerHolder> {

    private onItemClickListener listener;

    public PassengerAdapter(@NonNull FirestoreRecyclerOptions<Passenger> options) {
        super(options);
    }

    @Override
    protected void onBindViewHolder(@NonNull PassangerHolder holder, int position, @NonNull Passenger model) {

        holder.pName.setText(model.getName());
        holder.pPhone.setText(model.getphone());
        holder.pFrom.setText(model.getFrom());
        holder.pTo.setText(model.getTo());
        //holder.pStatus.setText(model.getStatus());
        //holder.pAmountPaid.setText(Double.toString(model.getAmountPaid()));

    }

    @NonNull
    @Override
    public PassangerHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.passenger_row, parent, false);
        return new PassangerHolder(view);
    }

    class PassangerHolder extends RecyclerView.ViewHolder {

        TextView pName, pPhone, pFrom, pTo, pStatus, pAmountPaid;

        public PassangerHolder(@NonNull View itemView) {
            super(itemView);

            pName = itemView.findViewById(R.id.passengerName);
            pPhone = itemView.findViewById(R.id.passengerPhone);
            pFrom = itemView.findViewById(R.id.passengerFrom);
            pTo = itemView.findViewById(R.id.passengerTo);
            pStatus = itemView.findViewById(R.id.passengerStatus);
            pAmountPaid = itemView.findViewById(R.id.amountPaid);

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
