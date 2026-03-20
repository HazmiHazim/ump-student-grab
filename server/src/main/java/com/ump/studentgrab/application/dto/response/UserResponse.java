package com.ump.studentgrab.application.dto.response;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record UserResponse(
        Long id,
        String email,
        String fullName,
        String gender,
        LocalDate birthDate,
        String matricNo,
        String phoneNo,
        String role,
        Long attachmentId,
        Boolean isVerified,
        String token,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
