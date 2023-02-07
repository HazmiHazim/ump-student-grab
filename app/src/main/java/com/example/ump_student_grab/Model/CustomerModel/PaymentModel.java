package com.example.ump_student_grab.Model.CustomerModel;

public class PaymentModel {

    private String From, To, Driver, Status, Time, Date;
    private double AmountPaid;

    public PaymentModel(){

    }

    public PaymentModel(String From, String To, String Driver, String Status, String Time, String Date, double AmountPaid) {
        this.From = From;
        this.To = To;
        this.Driver = Driver;
        this.Status = Status;
        this.AmountPaid = AmountPaid;
        this.Time = Time;
        this.Date = Date;
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

    public String getTime() {
        return Time;
    }

    public String getDate() {
        return Date;
    }
}
