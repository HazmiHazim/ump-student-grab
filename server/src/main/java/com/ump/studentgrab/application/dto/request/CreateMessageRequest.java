package com.ump.studentgrab.application.dto.request;

public record CreateMessageRequest(String content, String attachment, Long userId, Long chatId) {}
