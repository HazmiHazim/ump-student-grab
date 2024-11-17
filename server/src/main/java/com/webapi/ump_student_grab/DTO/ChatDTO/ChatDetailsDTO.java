package com.webapi.ump_student_grab.DTO.ChatDTO;

public class ChatDetailsDTO {
    private final Long chatId;
    private final Long senderId;
    private final Long recipientId;
    private final String recipientFullName;
    private final String lastMessage;

    public ChatDetailsDTO(Long chatId, Long senderId, Long recipientId, String recipientFullName, String lastMessage) {
        this.chatId = chatId;
        this.senderId = senderId;
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
