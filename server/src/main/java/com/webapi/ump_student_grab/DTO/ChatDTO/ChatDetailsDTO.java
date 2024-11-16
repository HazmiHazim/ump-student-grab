package com.webapi.ump_student_grab.DTO.ChatDTO;

public class ChatDetailsDTO {
    private final String recipientFullName;
    private final String lastMessage;

    public ChatDetailsDTO(String recipientFullName, String lastMessage) {
        this.recipientFullName = recipientFullName;
        this.lastMessage = lastMessage;
    }

    public String getRecipientFullName() {
        return recipientFullName;
    }

    public String getLastMessage() {
        return lastMessage;
    }
}
