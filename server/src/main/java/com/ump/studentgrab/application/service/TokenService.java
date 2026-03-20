package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.response.TokenResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.mapper.TokenMapper;
import com.ump.studentgrab.domain.model.Token;
import com.ump.studentgrab.domain.repository.TokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TokenService {

    private final TokenRepository tokenRepository;
    private final TokenMapper tokenMapper;

    @Transactional
    public TokenResponse createToken(Long userId, LocalDateTime expiredAt) {
        Token token = Token.builder()
                .token(generateTokenValue())
                .userId(userId)
                .expiredAt(expiredAt)
                .build();
        return tokenMapper.toResponse(tokenRepository.save(token));
    }

    public TokenResponse getTokenById(Long id) {
        return tokenMapper.toResponse(findById(id));
    }

    public TokenResponse getTokenByUserId(Long userId) {
        return tokenMapper.toResponse(findLatestByUserId(userId));
    }

    public TokenResponse getTokenByValue(String tokenValue) {
        return tokenMapper.toResponse(findByValue(tokenValue));
    }

    public List<TokenResponse> getAllTokens() {
        return tokenMapper.toResponseList(tokenRepository.findAll());
    }

    @Transactional
    public void expireToken(String tokenValue) {
        Token token = findByValue(tokenValue);
        token.setExpiredAt(LocalDateTime.now());
        tokenRepository.save(token);
    }

    @Transactional
    public TokenResponse refreshToken(Long userId) {
        tokenRepository.findTopByUserIdOrderByCreatedAtDesc(userId).ifPresent(existing -> {
            existing.setExpiredAt(LocalDateTime.now());
            tokenRepository.save(existing);
        });
        return createToken(userId, null);
    }

    // Internal — returns entity for use within the application layer
    public Token findByValue(String tokenValue) {
        return tokenRepository.findByToken(tokenValue)
                .orElseThrow(() -> new ResourceNotFoundException("Token not found"));
    }

    private Token findById(Long id) {
        return tokenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Token not found with id: " + id));
    }

    private Token findLatestByUserId(Long userId) {
        return tokenRepository.findTopByUserIdOrderByCreatedAtDesc(userId)
                .orElseThrow(() -> new ResourceNotFoundException("No token found for user: " + userId));
    }

    private String generateTokenValue() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
