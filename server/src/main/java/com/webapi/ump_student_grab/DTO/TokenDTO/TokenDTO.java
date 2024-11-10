package com.webapi.ump_student_grab.DTO.TokenDTO;

import java.time.LocalDateTime;

public class TokenDTO {
    private final Long id;
    private final String token;
    private final Long userId;
    private final LocalDateTime expiredAt;
    private final LocalDateTime createdAt;
    private final LocalDateTime modifiedAt;

    public TokenDTO(Long id, String token, Long userId, LocalDateTime expiredAt, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.id = id;
        this.token = token;
        this.userId = userId;
        this.expiredAt = expiredAt;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getId() {
        return id;
    }

    public String getToken() {
        return token;
    }

    public Long getUserId() {
        return userId;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
}
