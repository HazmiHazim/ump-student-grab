package com.webapi.ump_student_grab.DTO.ChatDTO;

import java.time.LocalDateTime;

public class MessageDTO {

    private final Long id;
    private final String content;
    private final String attachment;
    private final Long userId;
    private final Long chatId;
    private final LocalDateTime createdAt;
    private final LocalDateTime modifiedAt;

    public MessageDTO(Long id, String content, String attachment, Long userId, Long chatId, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.id = id;
        this.content = content;
        this.attachment = attachment;
        this.userId = userId;
        this.chatId = chatId;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getId() {
        return id;
    }

    public String getContent() {
        return content;
    }

    public String getAttachment() {
        return attachment;
    }

    public Long getUserId() {
        return userId;
    }

    public Long getChatId() {
        return chatId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
}
