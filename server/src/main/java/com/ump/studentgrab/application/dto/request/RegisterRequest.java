package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank(message = "Email is required")
        @Email(message = "Invalid email format")
        String email,

        @NotBlank(message = "Password is required")
        @Size(min = 8, max = 128, message = "Password must be between 8 and 128 characters")
        String password,

        @NotBlank(message = "Full name is required")
        String fullName,

        @NotBlank(message = "Matric number is required")
        String matricNo,

        @NotBlank(message = "Phone number is required")
        String phoneNo,

        @NotBlank(message = "Role is required")
        String role
) {}
