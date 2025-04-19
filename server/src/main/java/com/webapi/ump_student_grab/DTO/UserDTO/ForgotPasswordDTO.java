package com.webapi.ump_student_grab.DTO.UserDTO;

public class ForgotPasswordDTO {
    private String email;

    // Default constructor
    public ForgotPasswordDTO() {}

    public ForgotPasswordDTO(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
