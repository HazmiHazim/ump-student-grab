package com.example.ump_student_grab.Model.CustomerModel;

public class PaymentModel {

    private String From, To, Driver, Status;
    private double AmountPaid;

    public PaymentModel(){

    }

    public PaymentModel(String From, String To, String Driver, String Status, double AmountPaid) {
        this.From = From;
        this.To = To;
        this.Driver = Driver;
        this.Status = Status;
        this.AmountPaid = AmountPaid;
    }

    public String getFrom() {
        return From;
    }

    public String getTo() {
        return To;
    }

    public String getDriver() {
        return Driver;
    }

    public String getStatus() {
        return Status;
    }
    public double getAmountPaid() {
        return AmountPaid;
    }
}
