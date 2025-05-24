package com.webapi.ump_student_grab.WebSocket;

import com.webapi.ump_student_grab.DTO.ChatDTO.MessageWS;
import com.webapi.ump_student_grab.Model.Enum.MessageType;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

public class WebSocketEventListener {
    private final SimpMessageSendingOperations messageTemplate;

    public WebSocketEventListener(SimpMessageSendingOperations messageTemplate) {
        this.messageTemplate = messageTemplate;
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String participantName = (String) headerAccessor.getSessionAttributes().get("participantName");
        String roomId = (String) headerAccessor.getSessionAttributes().get("roomId");

//        if (participantName != null) {
//            MessageWS messageWS = new MessageWS();
//            messageWS.setMessageType(MessageType.OFFLINE);
//            messageWS.setSenderName(participantName);
//
//            messageTemplate.convertAndSend("/topic/room/" + roomId, messageWS);
//        }
    }
}
