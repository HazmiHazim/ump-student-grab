package com.webapi.ump_student_grab.DLL.Chat;

import com.webapi.ump_student_grab.Model.Entity.Chat;
import com.webapi.ump_student_grab.Model.Entity.Message;
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
        String query = "SELECT c FROM Chat c WHERE " +
                "(c.senderId = :senderId AND c.recipientId = :recipientId)" +
                " OR (c.senderId = :recipientId AND c.recipientId = :senderId)";
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
    public CompletableFuture<List<Chat>> getAllChats() {
        List<Chat> chats = entityManager.createQuery("SELECT c FROM Chat c", Chat.class).getResultList();
        return CompletableFuture.completedFuture(chats);
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
    public CompletableFuture<List<Message>> getAllMessages(Long chatId, Long userId, Long participantId) {
        String query = "SELECT m FROM Message m WHERE m.chatId = :chatId AND (m.userId = :userId OR m.userId = :participantId)";

        List<Message> messages = entityManager.createQuery(query, Message.class)
                .setParameter("chatId", chatId)
                .setParameter("userId", userId)
                .setParameter("participantId", participantId)
                .getResultList();

        return CompletableFuture.completedFuture(messages);
    }

    @Override
    @Async
    public CompletableFuture<Message> getLastMessage(Long chatId) {
        String query = "SELECT m FROM Message m WHERE m.chatId = :chatId ORDER BY m.createdAt DESC";
        Message message;

        try {
            message = entityManager.createQuery(query, Message.class)
                    .setParameter("chatId", chatId)
                    .setMaxResults(1)
                    .getSingleResult();
        } catch (NoResultException ex) {
            message = null;
        }

        return CompletableFuture.completedFuture(message);
    }
}
