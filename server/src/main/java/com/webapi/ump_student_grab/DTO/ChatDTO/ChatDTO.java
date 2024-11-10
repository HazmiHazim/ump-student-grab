package com.webapi.ump_student_grab.DTO.ChatDTO;

import java.time.LocalDateTime;

public class ChatDTO {

    private final Long id;
    private final Long senderId;
    private final Long recipientId;
    private final LocalDateTime createdAt;
    private final LocalDateTime modifiedAt;

    public ChatDTO(Long id, Long senderId, Long recipientId, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.id = id;
        this.senderId = senderId;
        this.recipientId = recipientId;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getId() {
        return id;
    }

    public Long getSenderId() {
        return senderId;
    }

    public Long getRecipientId() {
        return recipientId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
}
