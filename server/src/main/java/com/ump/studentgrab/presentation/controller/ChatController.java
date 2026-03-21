package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.request.CreateChatRequest;
import com.ump.studentgrab.application.dto.request.CreateMessageRequest;
import com.ump.studentgrab.application.dto.response.ChatDetailsResponse;
import com.ump.studentgrab.application.dto.response.ChatResponse;
import com.ump.studentgrab.application.dto.response.MessageResponse;
import com.ump.studentgrab.application.service.ChatService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chats")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    @PostMapping
    public ResponseEntity<ApiResponse<ChatResponse>> createChat(@Valid @RequestBody CreateChatRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Chat created successfully", chatService.createChat(request)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ChatResponse>>> getAllChats() {
        return ResponseEntity.ok(ApiResponse.success(chatService.getAllChats()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ChatResponse>> getChatById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(chatService.getChatById(id)));
    }

    @GetMapping("/participant")
    public ResponseEntity<ApiResponse<ChatResponse>> getChatByParticipant(
            @RequestParam Long senderId,
            @RequestParam Long recipientId) {
        return ResponseEntity.ok(ApiResponse.success(chatService.getChatByParticipants(senderId, recipientId)));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<List<ChatDetailsResponse>>> getChatDetailsForUser(@PathVariable Long userId) {
        return ResponseEntity.ok(ApiResponse.success(chatService.getChatDetailsForUser(userId)));
    }

    @PostMapping("/{chatId}/messages")
    public ResponseEntity<ApiResponse<MessageResponse>> createMessage(
            @PathVariable Long chatId,
            @Valid @RequestBody CreateMessageRequest request) {
        CreateMessageRequest withChatId = new CreateMessageRequest(request.content(), request.attachment(), request.userId(), chatId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Message sent", chatService.createMessage(withChatId)));
    }

    @GetMapping("/{chatId}/messages")
    public ResponseEntity<ApiResponse<List<MessageResponse>>> getMessages(
            @PathVariable Long chatId,
            @RequestParam Long userId,
            @RequestParam Long participantId) {
        return ResponseEntity.ok(ApiResponse.success(chatService.getMessages(chatId, userId, participantId)));
    }
}
