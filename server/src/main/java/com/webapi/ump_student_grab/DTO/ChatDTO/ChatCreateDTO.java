package com.webapi.ump_student_grab.DTO.ChatDTO;

public class ChatCreateDTO {
    private final Long senderId;
    private final Long recipientId;

    public ChatCreateDTO(Long senderId, Long recipientId) {
        this.senderId = senderId;
        this.recipientId = recipientId;
    }

    public Long getSenderId() {
        return senderId;
    }

    public Long getRecipientId() {
        return recipientId;
    }
}
