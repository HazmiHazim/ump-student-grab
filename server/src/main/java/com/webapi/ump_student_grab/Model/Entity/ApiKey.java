package com.webapi.ump_student_grab.Model.Entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "api_keys")
public class ApiKey {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Short id;
    @Column
    private String apiKey;
    @Column
    private LocalDateTime createdAt;
    @Column
    private Long createdBy;
    @Column
    private LocalDateTime expiredAt;

    public ApiKey() {} // Default constructor

    public ApiKey(Short id, String apiKey, LocalDateTime createdAt, Long createdBy, LocalDateTime expiredAt) {
        this.id = id;
        this.apiKey = apiKey;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.expiredAt = expiredAt;
    }

    public Short getId() {
        return id;
    }

    public void setId(Short id) {
        this.id = id;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.expiredAt = this.createdAt.plusYears(1);
    }
}
