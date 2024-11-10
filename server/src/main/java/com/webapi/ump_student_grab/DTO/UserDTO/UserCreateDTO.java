package com.webapi.ump_student_grab.DTO.UserDTO;

public class UserCreateDTO {

    private String email;
    private String password;
    private String fullName;
    private String matricNo;
    private String phoneNo;
    private String role;


    public UserCreateDTO(String email, String password, String fullName, String matricNo, String phoneNo, String role) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.matricNo = matricNo;
        this.phoneNo = phoneNo;
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
