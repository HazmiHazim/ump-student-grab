package com.webapi.ump_student_grab.DLL.Chat;

import com.webapi.ump_student_grab.Model.Chat;
import com.webapi.ump_student_grab.Model.Message;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IChatRepository {
    CompletableFuture<Chat> createChat(Chat chat);
    CompletableFuture<Chat> getChatById(Long id);
    CompletableFuture<Chat> getChatByParticipant(Long senderId, Long recipientId);
    CompletableFuture<List<Chat>> getAllChats();
    CompletableFuture<Message> createMessage(Message message);
    CompletableFuture<List<Message>> getAllMessages(Long chatId, Long userId, Long participantId);
    CompletableFuture<Message> getLastMessage(Long chatId, Long userId);
}
