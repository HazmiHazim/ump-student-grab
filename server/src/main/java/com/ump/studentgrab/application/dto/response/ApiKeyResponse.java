package com.ump.studentgrab.application.dto.response;

import java.time.LocalDateTime;

public record ApiKeyResponse(
        Short id,
        String apiKey,
        Long createdBy,
        LocalDateTime createdAt,
        LocalDateTime expiredAt
) {}
