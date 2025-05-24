package com.webapi.ump_student_grab.BLL.Chat;

import com.webapi.ump_student_grab.DTO.ChatDTO.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IChatServiceLogic {
    CompletableFuture<ChatDTO> createChat(ChatCreateDTO chatCreateDTO);
    CompletableFuture<ChatDTO> getChatById(Long id);
    CompletableFuture<ChatDTO> getChatByParticipant(Long senderId, Long recipientId);
    CompletableFuture<List<ChatDTO>> getAllChats();
    CompletableFuture<Integer> createMessage(MessageCreateDTO messageCreateDTO);
    CompletableFuture<List<MessageDTO>> getAllMessages(Long chatId, Long userId, Long participantId);
    CompletableFuture<List<ChatDetailsDTO>> getAllChatsWithDetails(Long userId);
    void messageBuffer(MessageWS message);
}
