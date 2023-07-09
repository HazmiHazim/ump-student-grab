package com.example.ump_student_grab.Model.AdminModel;


public class Driver {

    private String Name, phone, LicenseNo, CarBrand, PlateNo;

    public Driver() {

    }

    public Driver(String Name, String phone,  String LicenseNo, String CarBrand, String PlateNo){
        this.Name = Name;
        this.phone = phone;
        this.LicenseNo = LicenseNo;
        this.CarBrand = PlateNo;
        this.PlateNo = PlateNo;
    }

    public String getName() {
        return Name;
    }

    public String getphone() {
        return phone;
    }

    public String getLicenseNo() {
        return LicenseNo;
    }

    public String getCarBrand() {
        return CarBrand;
    }

    public String getPlateNo() {
        return PlateNo;
    }
}
