package com.webapi.ump_student_grab.DTO.LocationDTO;

import java.time.LocalDateTime;

public class LocationDTO {
    private final Long userId;
    private final Double latitude;
    private final Double longitude;
    private final LocalDateTime createdAt;
    private  final LocalDateTime modifiedAt;

    public LocationDTO(Long userId, Double latitude, Double longitude, LocalDateTime createdAt, LocalDateTime modifiedAt) {
        this.userId = userId;
        this.latitude = latitude;
        this.longitude = longitude;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }

    public Long getUserId() {
        return userId;
    }

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getModifiedAt() {
        return modifiedAt;
    }
}
