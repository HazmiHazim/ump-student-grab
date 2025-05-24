package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Chat.IChatServiceLogic;
import com.webapi.ump_student_grab.DTO.ChatDTO.*;
import com.webapi.ump_student_grab.Model.Entity.ApiResponse;
import com.webapi.ump_student_grab.Model.Enum.MessageStatus;
import com.webapi.ump_student_grab.Model.Enum.MessageType;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/chats")
public class ChatController {

    private final IChatServiceLogic service;
    private final SimpMessageSendingOperations messageSendOperation;

    public ChatController(IChatServiceLogic service, SimpMessageSendingOperations messageSendOperation) {
        this.service = service;
        this.messageSendOperation = messageSendOperation;
    }

    @PostMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> createChat(@RequestBody ChatCreateDTO chatCreateDTO) {
        return service.createChat(chatCreateDTO).thenApply(createdChatRoom -> {
            ApiResponse<ChatDTO> response;
            HttpStatus status;
            String message;

            if (createdChatRoom == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Failed to create chat.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.CREATED;
                message = "Chat created successfully.";
                response = new ApiResponse<>(status.value(), createdChatRoom, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> getChatById(@PathVariable Long id) {
        return service.getChatById(id).thenApply(existingChat -> {
            ApiResponse<ChatDTO> response;
            HttpStatus status;
            String message;

            if (existingChat == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Chat does not exists.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Chat found.";
                response = new ApiResponse<>(status.value(), existingChat, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/participant")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> getChatByParticipant(@RequestParam Long senderId, Long recipientId) {
        return service.getChatByParticipant(senderId, recipientId).thenApply(existingChat -> {
            ApiResponse<ChatDTO> response;
            HttpStatus status;
            String message;

            if (existingChat == null) {
                status = HttpStatus.NOT_FOUND;
                message = "No data found in our record.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Chat found.";
                response = new ApiResponse<>(status.value(), existingChat, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<ChatDTO>>>> getAllChats() {
        return service.getAllChats().thenApply(chats -> {
            ApiResponse<List<ChatDTO>> response;
            HttpStatus status;
            String message;

            if (chats == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Chat does not exists.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Chats found.";
                response = new ApiResponse<>(status.value(), chats, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/message")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<MessageDTO>>> createMessage(@RequestBody MessageCreateDTO messageCreateDTO) {
        return service.createMessage(messageCreateDTO).thenApply(createdMessage -> {
            String message;
            HttpStatus status = switch (createdMessage) {
                case 1 -> {
                    message = "User does not exist.";
                    yield HttpStatus.NOT_FOUND;
                }
                case 2 -> {
                    message = "Chat does not exist.";
                    yield HttpStatus.NOT_FOUND;
                }
                default -> {
                    message = "Chat created successfully.";
                    yield HttpStatus.CREATED;
                }
            };

            ApiResponse<MessageDTO> response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/message/{chatId}/{userId}/{participantId}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<MessageDTO>>>> getAllMessages(@PathVariable Long chatId, @PathVariable Long userId, @PathVariable Long participantId) {
        return service.getAllMessages(chatId, userId, participantId).thenApply(messages -> {
            ApiResponse<List<MessageDTO>> response;
            HttpStatus status;
            String message;

            if (messages == null || messages.isEmpty()) {
                status = HttpStatus.NOT_FOUND;
                message = "No data found in our record.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Messages found.";
                response = new ApiResponse<>(status.value(), messages, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/details/{userId}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<ChatDetailsDTO>>>> getAllChatsWithDetails(@PathVariable Long userId) {
        // Fetch all chats with details asynchronously and return the result
        return service.getAllChatsWithDetails(userId).thenApplyAsync(chats -> {
            ApiResponse<List<ChatDetailsDTO>> response;
            HttpStatus status;
            String message;

            if (chats == null || chats.isEmpty()) {
                status = HttpStatus.NOT_FOUND;
                message = "No data found in our record.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Messages found.";
                response = new ApiResponse<>(status.value(), chats, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @MessageMapping("/chat.sendMessage/{roomId}")
    public void sendMessage(@DestinationVariable String roomId, @Payload MessageWS message, SimpMessageHeaderAccessor headerAccessor) {
        // Automatically mark the user as online when they send a message
        headerAccessor.getSessionAttributes().put("participantId", message.getSenderId());
        headerAccessor.getSessionAttributes().put("participantName", message.getSenderName());
        headerAccessor.getSessionAttributes().put("roomId", roomId);
        message.setMessageType(MessageType.CHAT);
        message.setMessageStatus(MessageStatus.SENT);
        service.messageBuffer(message);

        // Send the message to the specific room
        messageSendOperation.convertAndSend("/topic/room/" + roomId, message);
    }

    @MessageMapping("/chat.addParticipant/{roomId}")
    public void addParticipant(@DestinationVariable String roomId, @Payload MessageWS message, SimpMessageHeaderAccessor headerAccessor) {
        // Add participant name in web socket session
        headerAccessor.getSessionAttributes().put("participantName", message.getSenderName());
        headerAccessor.getSessionAttributes().put("roomId", roomId);
        message.setMessageType(MessageType.ONLINE);
        messageSendOperation.convertAndSend("/topic/room/" + roomId, message);
    }
}
