package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateMessageRequest(
        @NotBlank(message = "Message content is required") String content,
        String attachment,
        @NotNull(message = "User ID is required") Long userId,
        @NotNull(message = "Chat ID is required") Long chatId
) {}
