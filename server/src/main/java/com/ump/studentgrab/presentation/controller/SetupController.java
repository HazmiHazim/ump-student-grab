package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.exception.UnauthorizedException;
import com.ump.studentgrab.domain.model.ApiKey;
import com.ump.studentgrab.domain.model.User;
import com.ump.studentgrab.domain.repository.ApiKeyRepository;
import com.ump.studentgrab.domain.repository.UserRepository;
import com.ump.studentgrab.presentation.response.ApiResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/setup")
@RequiredArgsConstructor
public class SetupController {

    private static final BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder(12);

    private final UserRepository userRepository;
    private final ApiKeyRepository apiKeyRepository;

    @PostMapping
    public ResponseEntity<ApiResponse<Map<String, String>>> setup(@Valid @RequestBody SetupRequest request) {
        // Block if any Super Admin already exists
        if (userRepository.findByRole("Super Admin").isPresent()) {
            log.warn("Setup endpoint rejected — Super Admin already exists");
            throw new UnauthorizedException("Setup has already been completed. This endpoint is disabled.");
        }

        // Create Super Admin user
        User admin = User.builder()
                .email(request.email())
                .password(PASSWORD_ENCODER.encode(request.password()))
                .fullName("Super Admin")
                .role("Super Admin")
                .isVerified(true)
                .build();
        userRepository.save(admin);
        log.info("Super Admin created: {}", request.email());

        // Generate API key
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        String keyValue = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

        ApiKey apiKey = ApiKey.builder()
                .apiKey(keyValue)
                .createdBy(admin.getId())
                .build();
        apiKeyRepository.save(apiKey);
        log.info("API key generated during setup for admin userId={}", admin.getId());

        Map<String, String> result = Map.of(
                "email", admin.getEmail(),
                "apiKey", keyValue
        );

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Setup complete. Save your API key — it won't be shown again.", result));
    }

    public record SetupRequest(
            @NotBlank @Email String email,
            @NotBlank @Size(min = 6, max = 128) String password
    ) {}
}
