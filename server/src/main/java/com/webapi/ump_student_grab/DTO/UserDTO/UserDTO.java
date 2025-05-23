package com.webapi.ump_student_grab.DTO.UserDTO;

import java.time.LocalDateTime;

public class UserDTO {
    private final Long id;
    private final String email;
    private final String fullName;
    private final String matricNo;
    private final String phoneNo;
    private final String role;
    private final Long attachmentId;
    private final Boolean isVerified;
    private final String token;
    private final LocalDateTime createdAt;
    private final LocalDateTime modifiedAt;

    public UserDTO(Long id, String email, String fullName, String matricNo, String phoneNo, String role, Long attachmentId, Boolean isVerified, String token, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.id = id;
        this.email = email;
        this.fullName = fullName;
        this.matricNo = matricNo;
        this.phoneNo = phoneNo;
        this.role = role;
        this.attachmentId = attachmentId;
        this.isVerified = isVerified;
        this.token = token;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public String getRole() {
        return role;
    }

    public Long getAttachmentId() {
        return attachmentId;
    }

    public Boolean getIsVerified() {
        return isVerified;
    }

    public String getToken() {
        return token;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
}
