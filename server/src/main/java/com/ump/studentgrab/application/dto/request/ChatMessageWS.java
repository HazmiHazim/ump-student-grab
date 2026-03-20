package com.ump.studentgrab.application.dto.request;

import com.ump.studentgrab.domain.enums.MessageStatus;
import com.ump.studentgrab.domain.enums.MessageType;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

// Mutable class (not a record) — STOMP deserializer requires a no-arg constructor + setters.
@Getter
@Setter
@NoArgsConstructor
public class ChatMessageWS {

    private Long chatId;
    private Long senderId;
    private String senderName;
    private String content;
    private MessageStatus messageStatus;
    private MessageType messageType;
    private Boolean isRead = false;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;
}
