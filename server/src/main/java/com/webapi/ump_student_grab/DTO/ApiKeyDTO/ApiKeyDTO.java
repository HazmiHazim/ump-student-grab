package com.webapi.ump_student_grab.DTO.ApiKeyDTO;

import java.time.LocalDateTime;

public class ApiKeyDTO {
    private Short id;
    private String apiKey;
    private LocalDateTime createdAt;
    private Long createdBy;
    private LocalDateTime expiredAt;

    public ApiKeyDTO(Short id, String apiKey, LocalDateTime createdAt, Long createdBy, LocalDateTime expiredAt) {
        this.id = id;
        this.apiKey = apiKey;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.expiredAt = expiredAt;
    }

    public Short getId() {
        return id;
    }

    public String getApiKey() {
        return apiKey;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }
}
