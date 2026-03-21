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
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ApiKeyService {

    private final ApiKeyRepository apiKeyRepository;
    private final UserRepository userRepository;
    private final ApiKeyMapper apiKeyMapper;

    @Transactional
    public ApiKeyResponse generateApiKey(Long userId) {
        log.info("Generating API key for userId={}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        if (!"Super Admin".equals(user.getRole())) {
            log.warn("API key generation denied — userId={} is not Super Admin", userId);
            throw new UnauthorizedException("Only Super Admins can generate API keys");
        }

        ApiKey apiKey = ApiKey.builder()
                .apiKey(generateSecureKey())
                .createdBy(userId)
                .build();

        ApiKeyResponse response = apiKeyMapper.toResponse(apiKeyRepository.save(apiKey));
        log.info("API key generated: id={} by userId={}", response.id(), userId);
        return response;
    }

    public void validateApiKey(String key) {
        ApiKey apiKey = apiKeyRepository.findByApiKey(key)
                .orElseThrow(() -> {
                    log.warn("API key validation failed — invalid key");
                    return new UnauthorizedException("Invalid API key");
                });

        if (apiKey.getExpiredAt() != null && apiKey.getExpiredAt().isBefore(LocalDateTime.now())) {
            log.warn("API key validation failed — expired key id={}", apiKey.getId());
            throw new UnauthorizedException("API key has expired");
        }
    }

    public List<ApiKeyResponse> getAllApiKeys() {
        return apiKeyMapper.toResponseList(apiKeyRepository.findAll());
    }

    private String generateSecureKey() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
