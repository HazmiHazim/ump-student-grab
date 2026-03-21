package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.Email;

import java.time.LocalDate;

public record UpdateUserRequest(
        @Email(message = "Invalid email format")
        String email,

        String fullName,
        String gender,
        LocalDate birthDate,
        String matricNo,
        String phoneNo,
        String role,
        Long attachmentId
) {}
