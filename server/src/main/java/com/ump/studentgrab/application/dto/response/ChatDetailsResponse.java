package com.ump.studentgrab.application.dto.response;

public record ChatDetailsResponse(
        Long chatId,
        Long senderId,
        String senderFullName,
        Long recipientId,
        String recipientFullName,
        String lastMessage
) {}
