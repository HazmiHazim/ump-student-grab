package com.webapi.ump_student_grab.DLL.ApiKey;

import com.webapi.ump_student_grab.Model.Entity.ApiKey;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
public class ApiKeyRepository implements IApiKeyRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<ApiKey> createApiKey(ApiKey apiKey) {
        entityManager.persist(apiKey);
        entityManager.flush();
        return CompletableFuture.completedFuture(apiKey);
    }

    @Override
    @Async
    public CompletableFuture<ApiKey> getApiKey(String apiKey) {
        ApiKey key = entityManager.createQuery("SELECT k FROM ApiKey k WHERE k.apiKey = :apiKey", ApiKey.class)
                .setParameter("apiKey", apiKey)
                .getSingleResult();

        return CompletableFuture.completedFuture(key);
    }

    @Override
    @Async
    public CompletableFuture<List<ApiKey>> getAllApiKeys() {
        List<ApiKey> apiKeys = entityManager.createQuery("SELECT k FROM ApiKey k", ApiKey.class).getResultList();
        return CompletableFuture.completedFuture(apiKeys);
    }
}
