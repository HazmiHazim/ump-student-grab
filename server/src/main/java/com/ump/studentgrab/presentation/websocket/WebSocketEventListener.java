package com.ump.studentgrab.presentation.websocket;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import lombok.RequiredArgsConstructor;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketEventListener {

    private final SimpMessageSendingOperations messagingTemplate;

    @EventListener
    public void handleDisconnect(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        if (accessor.getSessionAttributes() == null) return;
        String participantName = (String) accessor.getSessionAttributes().get("participantName");
        String roomId = (String) accessor.getSessionAttributes().get("roomId");
        log.info("WebSocket disconnected: participant={}, roomId={}, sessionId={}", participantName, roomId, accessor.getSessionId());

        // Offline broadcast — uncomment when offline status is needed on the client
//        if (participantName != null && roomId != null) {
//            ChatMessageWS offlineMessage = new ChatMessageWS();
//            offlineMessage.setMessageType(MessageType.OFFLINE);
//            offlineMessage.setSenderName(participantName);
//            messagingTemplate.convertAndSend("/topic/room/" + roomId, offlineMessage);
//        }
    }
}
