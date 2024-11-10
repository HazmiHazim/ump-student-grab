package com.webapi.ump_student_grab.Model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "chats")
public class Chat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column
    private Long senderId;
    @Column
    private Long recipientId ;
    @Column
    private LocalDateTime createdAt;
    @Column
    private LocalDateTime modifiedAt;

    // No-argument constructor is required by JPA
    public Chat() {}

    public Chat(Long id, Long senderId, Long recipientId, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.id = id;
        this.senderId = senderId;
        this.recipientId = recipientId;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public Long getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(Long recipientId) {
        this.recipientId = recipientId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.modifiedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }
}
