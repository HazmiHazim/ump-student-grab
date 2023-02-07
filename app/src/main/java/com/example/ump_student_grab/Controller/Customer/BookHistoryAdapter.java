package com.example.ump_student_grab.Controller.Customer;


import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import android.widget.TextView;


import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.ump_student_grab.Model.CustomerModel.PaymentModel;
import com.example.ump_student_grab.R;
import com.firebase.ui.firestore.FirestoreRecyclerAdapter;
import com.firebase.ui.firestore.FirestoreRecyclerOptions;


public class BookHistoryAdapter extends FirestoreRecyclerAdapter<PaymentModel, BookHistoryAdapter.BookHistoryHolder> {



    public BookHistoryAdapter(@NonNull FirestoreRecyclerOptions<PaymentModel> options) {
        super(options);
    }

    @Override
    protected void onBindViewHolder(@NonNull BookHistoryHolder holder, int position, @NonNull PaymentModel model) {

        holder.From.setText(model.getFrom());
        holder.To.setText(model.getTo());
        holder.Time.setText(model.getTime());
        holder.Date.setText(model.getDate());

    }

    @NonNull
    @Override
    public BookHistoryHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.book_history_list, parent,false);
        return new BookHistoryHolder(v);
    }


    class BookHistoryHolder extends RecyclerView.ViewHolder {

        TextView From, To, Date, Time;

        public BookHistoryHolder(@NonNull View itemView) {
            super(itemView);

            From = itemView.findViewById(R.id.history_from);
            To = itemView.findViewById(R.id.history_to);
            Date = itemView.findViewById(R.id.history_date);
            Time = itemView.findViewById(R.id.history_time);

        }
    }
}
