package com.webapi.ump_student_grab.DTO.ChatDTO;

import com.webapi.ump_student_grab.Model.Enum.MessageStatus;
import com.webapi.ump_student_grab.Model.Enum.MessageType;

import java.time.LocalDateTime;

public class MessageWS {
    private Long chatId;
    private Long senderId;
    private String senderName;
    private String content;
    private MessageStatus messageStatus;
    private MessageType messageType;
    private Boolean isRead = false; // Set default false
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    public MessageWS(Long chatId, Long senderId, String senderName, String content, MessageStatus messageStatus, MessageType messageType, Boolean isRead, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.chatId = chatId;
        this.senderId = senderId;
        this.senderName = senderName;
        this.content = content;
        this.messageStatus = messageStatus;
        this.messageType = messageType;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getChatId() {
        return chatId;
    }

    public void setChatId(Long chatId) {
        this.chatId = chatId;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public MessageStatus getMessageStatus() {
        return messageStatus;
    }

    public void setMessageStatus(MessageStatus messageStatus) {
        this.messageStatus = messageStatus;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public void setMessageType(MessageType messageType) {
        this.messageType = messageType;
    }

    public Boolean getRead() {
        return isRead;
    }

    public void setRead(Boolean read) {
        isRead = read;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(LocalDateTime modifiedAt) {
        this.modifiedAt = modifiedAt;
    }
}
