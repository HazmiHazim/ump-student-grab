package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.NotNull;

public record CreateChatRequest(
        @NotNull(message = "Sender ID is required") Long senderId,
        @NotNull(message = "Recipient ID is required") Long recipientId
) {}
