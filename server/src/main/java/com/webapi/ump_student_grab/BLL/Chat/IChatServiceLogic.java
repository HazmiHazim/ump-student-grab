package com.webapi.ump_student_grab.BLL.Chat;

import com.webapi.ump_student_grab.DTO.ChatDTO.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IChatServiceLogic {
    CompletableFuture<ChatDTO> createChat(ChatCreateDTO chatCreateDTO, String apiKey);
    CompletableFuture<ChatDTO> getChatById(Long id, String apiKey);
    CompletableFuture<ChatDTO> getChatByParticipant(Long senderId, Long recipientId, String apiKey);
    CompletableFuture<List<ChatDTO>> getAllChats(String apiKey);
    CompletableFuture<Integer> createMessage(MessageCreateDTO messageCreateDTO, String apiKey);
    CompletableFuture<List<MessageDTO>> getAllMessages(Long chatId, Long userId, Long participantId, String apiKey);
    CompletableFuture<List<ChatDetailsDTO>> getAllChatsWithDetails(Long userId, String apiKey);
    void messageBuffer(MessageWS message);
}
