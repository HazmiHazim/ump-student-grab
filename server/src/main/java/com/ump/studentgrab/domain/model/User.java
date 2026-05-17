package com.ump.studentgrab.domain.model;

import com.ump.studentgrab.domain.enums.UserRole;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;
    @Column(nullable = false)
    private String password;
    private String fullName;
    private String gender;
    private LocalDate birthDate;
    private String matricNo;
    private String phoneNo;

    @Enumerated(EnumType.STRING)
    private UserRole role;

    private Long attachmentId;

    // Driver-specific fields (null for passengers)
    private String icNo;
    private String carBrand;
    private String carModel;
    private String plateNo;
    private String carColour;
    private String licenseType;

    @Column(nullable = false)
    @Builder.Default
    private Boolean isVerified = false;

    private String token;

    @Column(updatable = false)
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.modifiedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.modifiedAt = LocalDateTime.now();
    }
}
