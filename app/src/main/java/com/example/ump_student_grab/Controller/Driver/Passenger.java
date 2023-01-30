package com.example.ump_student_grab.Controller.Driver;

public class Passenger {

    private String Name, phone, From, To;

    public Passenger() {

    }

    public Passenger(String Name, String phone, String From, String To) {
        this.Name = Name;
        this.phone = phone;
        this.From = From;
        this.To = To;
    }

    public String getName() {
        return Name;
    }

    public String getphone() {
        return phone;
    }

    public String getFrom() {
        return From;
    }

    public String getTo() {
        return To;
    }
}
