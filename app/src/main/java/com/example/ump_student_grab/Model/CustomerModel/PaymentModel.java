package com.example.ump_student_grab.Model.CustomerModel;

public class PaymentModel {

    private String From, To, Driver, Status;
    private double amountPaid;

    public PaymentModel(){

    }

    public PaymentModel(String From, String To, String Driver, String Status, double amountPaid) {
        this.From = From;
        this.To = To;
        this.Driver = Driver;
        this.Status = Status;
        this.amountPaid = amountPaid;
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
        return amountPaid;
    }
}
