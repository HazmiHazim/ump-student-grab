package com.ump.studentgrab.application.dto.request;

public record RegisterRequest(
        String email,
        String password,
        String fullName,
        String matricNo,
        String phoneNo,
        String role
) {}
