package com.webapi.ump_student_grab.BLL.ApiKey;

import com.webapi.ump_student_grab.DLL.ApiKey.IApiKeyRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyCreateDTO;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyDTO;
import com.webapi.ump_student_grab.Mapper.ApiKeyMapper;
import com.webapi.ump_student_grab.Model.Entity.ApiKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class ApiKeyServiceLogic implements IApiKeyServiceLogic {

    private final IApiKeyRepository repo;
    private final IUserRepository uRepo;
    private final ApiKeyMapper mapper;

    @Value("${SECRET_KEY}")
    private String SECRET_KEY;

    public ApiKeyServiceLogic(IApiKeyRepository repo, IUserRepository uRepo, ApiKeyMapper mapper) {
        this.repo = repo;
        this.uRepo = uRepo;
        this.mapper = mapper;
    }

    @Override
    public CompletableFuture<ApiKeyCreateDTO> generateApiKey(String secretKey, Long userId) {
        return uRepo.getUserById(userId).thenCompose(existingUser -> {
            if (existingUser == null) {
                return CompletableFuture.completedFuture(null);
            }

            if (!existingUser.getRole().equals("Super Admin")) {
                return CompletableFuture.completedFuture(null);
            }

            if (!secretKey.equals(SECRET_KEY)) {
                return CompletableFuture.completedFuture(null);
            }

            String newApiKey = apiKeyGenerator();
            ApiKey key = new ApiKey(null, newApiKey, null, existingUser.getId(), null);
            return repo.createApiKey(key).thenApply(mapper::apiKeyToApiKeyCreateDTO);
        });
    }

    @Override
    public CompletableFuture<Boolean> checkApiKey(String key) {
        return repo.getApiKey(key).thenCompose(existingKey -> {
            if (existingKey == null) {
                return CompletableFuture.completedFuture(false);
            }

            if (existingKey.getExpiredAt().isBefore(LocalDateTime.now())) {
                return CompletableFuture.completedFuture(false);
            }

            return CompletableFuture.completedFuture(true);
        });
    }

    @Override
    public CompletableFuture<List<ApiKeyDTO>> getAllApiKeys(String secretKey) {
        if (!secretKey.equals(SECRET_KEY)) {
            return CompletableFuture.completedFuture(null);
        }

        return repo.getAllApiKeys().thenApply(mapper::apiKeyListToApiKeyDTOList);
    }

    private String apiKeyGenerator() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
