package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.response.ApiKeyResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.exception.UnauthorizedException;
import com.ump.studentgrab.application.mapper.ApiKeyMapper;
import com.ump.studentgrab.domain.model.ApiKey;
import com.ump.studentgrab.domain.model.User;
import com.ump.studentgrab.domain.repository.ApiKeyRepository;
import com.ump.studentgrab.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ApiKeyService {

    private final ApiKeyRepository apiKeyRepository;
    private final UserRepository userRepository;
    private final ApiKeyMapper apiKeyMapper;

    @Value("${app.secret-key}")
    private String appSecretKey;

    @Transactional
    public ApiKeyResponse generateApiKey(String secretKey, Long userId) {
        validateSecretKey(secretKey);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        if (!"Super Admin".equals(user.getRole())) {
            throw new UnauthorizedException("Only Super Admins can generate API keys");
        }

        ApiKey apiKey = ApiKey.builder()
                .apiKey(generateSecureKey())
                .createdBy(userId)
                .build();

        return apiKeyMapper.toResponse(apiKeyRepository.save(apiKey));
    }

    public void validateApiKey(String key) {
        ApiKey apiKey = apiKeyRepository.findByApiKey(key)
                .orElseThrow(() -> new UnauthorizedException("Invalid API key"));

        if (apiKey.getExpiredAt().isBefore(LocalDateTime.now())) {
            throw new UnauthorizedException("API key has expired");
        }
    }

    public List<ApiKeyResponse> getAllApiKeys(String secretKey) {
        validateSecretKey(secretKey);
        return apiKeyMapper.toResponseList(apiKeyRepository.findAll());
    }

    private void validateSecretKey(String secretKey) {
        if (!appSecretKey.equals(secretKey)) {
            throw new UnauthorizedException("Invalid secret key");
        }
    }

    private String generateSecureKey() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
