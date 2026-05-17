package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.exception.UnauthorizedException;
import com.ump.studentgrab.domain.enums.UserRole;
import com.ump.studentgrab.domain.model.User;
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

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/setup")
@RequiredArgsConstructor
public class SetupController {

    private static final BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder(12);

    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<ApiResponse<Map<String, String>>> setup(@Valid @RequestBody SetupRequest request) {
        if (userRepository.findByRole(UserRole.ADMIN).isPresent()) {
            log.warn("Setup endpoint rejected — Admin already exists");
            throw new UnauthorizedException("Setup has already been completed. This endpoint is disabled.");
        }

        User admin = User.builder()
                .email(request.email())
                .password(PASSWORD_ENCODER.encode(request.password()))
                .fullName("Super Admin")
                .role(UserRole.ADMIN)
                .isVerified(true)
                .build();
        userRepository.save(admin);
        log.info("Super Admin created: {}", request.email());

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Setup complete. Super Admin account created.", Map.of("email", admin.getEmail())));
    }

    public record SetupRequest(
            @NotBlank @Email String email,
            @NotBlank @Size(min = 6, max = 128) String password
    ) {}
}
