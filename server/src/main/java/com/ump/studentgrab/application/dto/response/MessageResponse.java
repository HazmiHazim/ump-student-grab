package com.ump.studentgrab.application.dto.response;

import com.ump.studentgrab.domain.enums.MessageStatus;

import java.time.LocalDateTime;

public record MessageResponse(
        Long id,
        String content,
        String attachment,
        Long userId,
        Long chatId,
        MessageStatus messageStatus,
        Boolean isRead,
        LocalDateTime createdAt,
        LocalDateTime modifiedAt
) {}
