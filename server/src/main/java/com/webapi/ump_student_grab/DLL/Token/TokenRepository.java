package com.webapi.ump_student_grab.DLL.Token;

import com.webapi.ump_student_grab.Model.Entity.Token;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
public class TokenRepository implements ITokenRepository{

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<Token> createToken(Token token) {
        entityManager.persist(token);
        entityManager.flush();
        return CompletableFuture.completedFuture(token);
    }

    @Override
    @Async
    public CompletableFuture<Token> getTokenById(Long id) {
        Token token = entityManager.find(Token.class, id);
        return CompletableFuture.completedFuture(token);
    }

    @Override
    @Async
    public CompletableFuture<Token> getTokenByToken(String token) {
        List<Token> tokens = entityManager.createQuery("SELECT t FROM Token t WHERE t.token = :token", Token.class)
                .setParameter("token", token)
                .setMaxResults(1)
                .getResultList();

        return CompletableFuture.completedFuture(tokens.isEmpty() ? null : tokens.getFirst());
    }

    @Override
    @Async
    public CompletableFuture<Token> getTokenByUserId(Long userId) {
        List<Token> tokens = entityManager.createQuery("SELECT t FROM Token t WHERE t.userId = :userId ORDER BY t.createdAt DESC", Token.class)
                .setParameter("userId", userId)
                .setMaxResults(1)
                .getResultList();

        return CompletableFuture.completedFuture(tokens.isEmpty() ? null : tokens.getFirst());
    }

    @Override
    @Async
    public CompletableFuture<List<Token>> getAllTokens() {
        List<Token> tokens = entityManager.createQuery("SELECT t FROM Token t", Token.class).getResultList();
        return CompletableFuture.completedFuture(tokens);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<Token> updateToken(Token token) {
        Token updatedToken = entityManager.merge(token);
        return CompletableFuture.completedFuture(updatedToken);
    }
}
