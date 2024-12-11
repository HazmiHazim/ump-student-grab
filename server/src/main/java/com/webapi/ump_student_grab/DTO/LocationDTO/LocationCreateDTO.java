package com.webapi.ump_student_grab.DTO.LocationDTO;

public class LocationCreateDTO {
    private final Long userId;
    private final Double latitude;
    private final Double longitude;

    public LocationCreateDTO(Long userId, Double latitude, Double longitude) {
        this.userId = userId;
        this.latitude = latitude;
        this.longitude = longitude;
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
}
