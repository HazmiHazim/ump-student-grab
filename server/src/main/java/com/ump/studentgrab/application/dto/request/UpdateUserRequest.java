package com.ump.studentgrab.application.dto.request;

import java.time.LocalDate;

public record UpdateUserRequest(
        String email,
        String fullName,
        String gender,
        LocalDate birthDate,
        String matricNo,
        String phoneNo,
        String role,
        Long attachmentId
) {}
