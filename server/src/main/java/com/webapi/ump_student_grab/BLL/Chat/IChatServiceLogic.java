package com.webapi.ump_student_grab.BLL.Chat;

import com.webapi.ump_student_grab.DTO.ChatDTO.ChatCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.ChatDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageDTO;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IChatServiceLogic {
    CompletableFuture<ChatDTO> createChat(ChatCreateDTO chatCreateDTO);
    CompletableFuture<ChatDTO> getChatById(Long id);
    CompletableFuture<ChatDTO> getChatByParticipant(Long senderId, Long recipientId);
    CompletableFuture<Integer> createMessage(MessageCreateDTO messageCreateDTO);
    CompletableFuture<List<MessageDTO>> getAllMessages(Long userId, Long chatId);
}
