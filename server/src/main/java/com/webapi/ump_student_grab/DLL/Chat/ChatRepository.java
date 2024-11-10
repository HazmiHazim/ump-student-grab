package com.webapi.ump_student_grab.DLL.Chat;

import com.webapi.ump_student_grab.Model.Chat;
import com.webapi.ump_student_grab.Model.Message;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
public class ChatRepository implements IChatRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<Chat> createChat(Chat chat) {
        entityManager.persist(chat);
        entityManager.flush();
        return CompletableFuture.completedFuture(chat);
    }

    @Override
    @Async
    public CompletableFuture<Chat> getChatById(Long id) {
        Chat chat = entityManager.find(Chat.class, id);
        return CompletableFuture.completedFuture(chat);
    }

    @Override
    @Async
    public CompletableFuture<Chat> getChatByParticipant(Long senderId, Long recipientId) {
        String query = "SELECT c FROM Chat c WHERE c.senderId = :senderId AND c.recipientId = :recipientId";
        Chat chat;
        try {
            chat = entityManager.createQuery(query, Chat.class)
                    .setParameter("senderId", senderId)
                    .setParameter("recipientId", recipientId)
                    .getSingleResult();
        } catch (NoResultException ex) {
            chat = null;
        }

        return CompletableFuture.completedFuture(chat);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<Message> createMessage(Message message) {
        entityManager.persist(message);
        entityManager.flush();
        return CompletableFuture.completedFuture(message);
    }

    @Override
    @Async
    public CompletableFuture<List<Message>> getAllMessages(Long userId, Long chatId) {
        String query = "SELECT m FROM Message m WHERE m.userId = :userId AND m.chatId = :chatId";

        List<Message> messages = entityManager.createQuery(query, Message.class)
                .setParameter("userId", userId)
                .setParameter("chatId", chatId)
                .getResultList();

        return CompletableFuture.completedFuture(messages);
    }
}
