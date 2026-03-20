package com.ump.studentgrab.application.dto.response;

import java.time.LocalDateTime;

public record TokenResponse(
        Long id,
        String token,
        Long userId,
        LocalDateTime expiredAt,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
