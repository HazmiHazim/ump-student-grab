package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record DriverRegisterRequest(
        @NotBlank(message = "Email is required")
        @Email(message = "Invalid email format")
        String email,

        @NotBlank(message = "Password is required")
        @Size(min = 8, max = 128, message = "Password must be between 8 and 128 characters")
        String password,

        @NotBlank(message = "Full name is required")
        String fullName,

        @NotBlank(message = "IC number is required")
        String icNo,

        @NotBlank(message = "Phone number is required")
        String phoneNo,

        @NotBlank(message = "Car brand is required")
        String carBrand,

        @NotBlank(message = "Car model is required")
        String carModel,

        @NotBlank(message = "Plate number is required")
        String plateNo,

        @NotBlank(message = "Car colour is required")
        String carColour,

        @NotBlank(message = "License type is required")
        String licenseType
) {}
