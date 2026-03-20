package com.ump.studentgrab.presentation.websocket;

import com.ump.studentgrab.application.dto.request.ChatMessageWS;
import com.ump.studentgrab.application.service.MessageBuffer;
import com.ump.studentgrab.domain.enums.MessageStatus;
import com.ump.studentgrab.domain.enums.MessageType;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final SimpMessageSendingOperations messagingTemplate;
    private final MessageBuffer messageBuffer;

    @MessageMapping("/chat.sendMessage/{roomId}")
    public void sendMessage(
            @DestinationVariable String roomId,
            @Payload ChatMessageWS message,
            SimpMessageHeaderAccessor headerAccessor) {

        headerAccessor.getSessionAttributes().put("participantId", message.getSenderId());
        headerAccessor.getSessionAttributes().put("participantName", message.getSenderName());
        headerAccessor.getSessionAttributes().put("roomId", roomId);

        message.setMessageType(MessageType.CHAT);
        message.setMessageStatus(MessageStatus.SENT);

        messageBuffer.add(message);
        messagingTemplate.convertAndSend("/topic/room/" + roomId, message);
    }

    @MessageMapping("/chat.addParticipant/{roomId}")
    public void addParticipant(
            @DestinationVariable String roomId,
            @Payload ChatMessageWS message,
            SimpMessageHeaderAccessor headerAccessor) {

        headerAccessor.getSessionAttributes().put("participantName", message.getSenderName());
        headerAccessor.getSessionAttributes().put("roomId", roomId);

        message.setMessageType(MessageType.ONLINE);
        messagingTemplate.convertAndSend("/topic/room/" + roomId, message);
    }
}
