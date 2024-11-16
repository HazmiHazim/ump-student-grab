package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Chat.IChatServiceLogic;
import com.webapi.ump_student_grab.DTO.ChatDTO.*;
import com.webapi.ump_student_grab.Model.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/chats")
public class ChatController {

    private final IChatServiceLogic _service;

    public ChatController(IChatServiceLogic service) {
        this._service = service;
    }

    @PostMapping("/createChat")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> createChat(@RequestBody ChatCreateDTO chatCreateDTO) {
        return _service.createChat(chatCreateDTO).thenApply(createdChatRoom -> {
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

    @GetMapping("/getChatById/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> getChatById(@PathVariable Long id) {
        return _service.getChatById(id).thenApply(existingChat -> {
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

    @GetMapping("/getChatByParticipant")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ChatDTO>>> getChatByParticipant(@RequestParam Long senderId, Long recipientId) {
        return _service.getChatByParticipant(senderId, recipientId).thenApply(existingChat -> {
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

    @GetMapping("/allChats")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<ChatDTO>>>> getAllChats() {
        return _service.getAllChats().thenApply(chats -> {
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

    @PostMapping("/createMessage")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<MessageDTO>>> createMessage(@RequestBody MessageCreateDTO messageCreateDTO) {
        return _service.createMessage(messageCreateDTO).thenApply(createdMessage -> {
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

    @GetMapping("/allMessages/{userId}/{chatId}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<MessageDTO>>>> getAllMessages(@PathVariable Long userId, @PathVariable Long chatId) {
        return _service.getAllMessages(userId, chatId).thenApply(messages -> {
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

    @GetMapping("/allChatsDetails")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<ChatDetailsDTO>>>> getAllChatsWithDetails() {
        // Fetch all chats with details asynchronously and return the result
        return _service.getAllChatsWithDetails().thenApplyAsync(chats -> {
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

    @MessageMapping("/chatroom")
    @SendTo("/topic/chatroom")
    public CompletableFuture<ChatCreateDTO> broadcastChat(@Payload ChatCreateDTO chatCreateDTO) {
        // Save the message to the database asynchronously
        CompletableFuture<Void> saveTask = CompletableFuture.runAsync(() -> {
            _service.createChat(chatCreateDTO).join(); // Save and wait for completion in the background
        });

        // Broadcast the message asynchronously
        return CompletableFuture.supplyAsync(() -> {
            // Directly return the DTO for broadcasting
            return chatCreateDTO;
        });
    }

    @MessageMapping("/chat")
    @SendTo("/topic/chat")
    public CompletableFuture<MessageCreateDTO> broadcastMessage(@Payload MessageCreateDTO messageCreateDTO) {
        // Save the message to the database asynchronously
        CompletableFuture<Void> saveTask = CompletableFuture.runAsync(() -> {
            _service.createMessage(messageCreateDTO).join(); // Save and wait for completion in the background
        });

        // Broadcast the message asynchronously
        return CompletableFuture.supplyAsync(() -> {
            // Directly return the DTO for broadcasting
            return messageCreateDTO;
        });
    }
}
