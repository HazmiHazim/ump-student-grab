package com.webapi.ump_student_grab.DTO.ApiKeyDTO;

import java.time.LocalDateTime;

public class ApiKeyCreateDTO {
    private String apiKey;
    private LocalDateTime createdAt;
    private LocalDateTime expiredAt;

    public ApiKeyCreateDTO(String apiKey, LocalDateTime createdAt, LocalDateTime expiredAt) {
        this.apiKey = apiKey;
        this.createdAt = createdAt;
        this.expiredAt = expiredAt;
    }

    public String getApiKey() {
        return apiKey;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }
}
