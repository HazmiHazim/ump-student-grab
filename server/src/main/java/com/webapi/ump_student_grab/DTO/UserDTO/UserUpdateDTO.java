package com.webapi.ump_student_grab.DTO.UserDTO;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserUpdateDTO {

    private String email;
    private String fullName;
    private final String gender;
    private final LocalDate birthDate;
    private String matricNo;
    private String phoneNo;
    private String role;
    private Long attachmentId;

    public UserUpdateDTO(String email, String fullName, String gender, LocalDate birthDate,
                         String matricNo, String phoneNo, String role, Long attachmentId) {
        this.email = email;
        this.fullName = fullName;
        this.gender = gender;
        this.birthDate = birthDate;
        this.matricNo = matricNo;
        this.phoneNo = phoneNo;
        this.role = role;
        this.attachmentId = attachmentId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public LocalDate getBirthDate() {
        return birthDate;
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

    public Long getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(Long attachmentId) {
        this.attachmentId = attachmentId;
    }
}
