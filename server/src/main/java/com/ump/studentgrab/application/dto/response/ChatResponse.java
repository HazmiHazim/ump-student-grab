package com.ump.studentgrab.application.dto.response;

import java.time.LocalDateTime;

public record ChatResponse(
        Long id,
        Long senderId,
        Long recipientId,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
