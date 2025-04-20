package com.webapi.ump_student_grab.DTO.ChatDTO;

public class ChatDetailsDTO {
    private final Long chatId;
    private final Long senderId;
    private final String senderFullName;
    private final Long recipientId;
    private final String recipientFullName;
    private final String lastMessage;

    public ChatDetailsDTO(Long chatId, Long senderId, String senderFullName, Long recipientId, String recipientFullName, String lastMessage) {
        this.chatId = chatId;
        this.senderId = senderId;
        this.senderFullName = senderFullName;
        this.recipientId = recipientId;
        this.recipientFullName = recipientFullName;
        this.lastMessage = lastMessage;
    }

    public Long getChatId() {
        return chatId;
    }

    public Long getSenderId() {
        return senderId;
    }

    public String getSenderFullName() {
        return senderFullName;
    }

    public Long getRecipientId() {
        return recipientId;
    }

    public String getRecipientFullName() {
        return recipientFullName;
    }

    public String getLastMessage() {
        return lastMessage;
    }
}
