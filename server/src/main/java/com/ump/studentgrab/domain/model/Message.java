package com.ump.studentgrab.domain.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "messages")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String content;

    @Column(nullable = true)
    private String attachment;

    private Long userId;
    private Long chatId;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) this.createdAt = LocalDateTime.now();
        if (this.modifiedAt == null) this.modifiedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }
}
