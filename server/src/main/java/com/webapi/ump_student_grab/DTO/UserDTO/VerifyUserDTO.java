package com.webapi.ump_student_grab.DTO.UserDTO;

public class VerifyUserDTO {
    private String email;

    // Default constructor
    public VerifyUserDTO() {}

    public VerifyUserDTO(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
