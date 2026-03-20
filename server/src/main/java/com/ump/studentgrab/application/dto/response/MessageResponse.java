package com.ump.studentgrab.application.dto.response;

import java.time.LocalDateTime;

public record MessageResponse(
        Long id,
        String content,
        String attachment,
        Long userId,
        Long chatId,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
