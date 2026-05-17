package com.ump.studentgrab.application.dto.response;

import com.ump.studentgrab.domain.enums.UserRole;

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
        UserRole role,
        Long attachmentId,
        String icNo,
        String carBrand,
        String carModel,
        String plateNo,
        String carColour,
        String licenseType,
        Boolean isVerified,
        String token,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
