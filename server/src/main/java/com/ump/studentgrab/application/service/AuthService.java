package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.request.*;
import com.ump.studentgrab.application.dto.response.TokenResponse;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.application.exception.DuplicateResourceException;
import com.ump.studentgrab.application.exception.InvalidCredentialsException;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.exception.TokenExpiredException;
import com.ump.studentgrab.application.mapper.UserMapper;
import com.ump.studentgrab.application.port.EmailService;
import com.ump.studentgrab.domain.model.Token;
import com.ump.studentgrab.domain.model.User;
import com.ump.studentgrab.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthService {

    private static final BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder(16);

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final UserService userService;
    private final TokenService tokenService;
    private final EmailService emailService;

    @Transactional
    public UserResponse register(RegisterRequest request) {
        userService.validateEmailFormat(request.email());

        if (userRepository.findByEmail(request.email()).isPresent()) {
            throw new DuplicateResourceException("Email is already registered: " + request.email());
        }

        User user = userMapper.toEntity(request);
        user.setPassword(PASSWORD_ENCODER.encode(request.password()));
        return userMapper.toResponse(userRepository.save(user));
    }

    @Transactional
    public UserResponse login(LoginRequest request) {
        userService.validateEmailFormat(request.email());

        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new InvalidCredentialsException("Invalid email or password"));

        if (!PASSWORD_ENCODER.matches(request.password(), user.getPassword())) {
            throw new InvalidCredentialsException("Invalid email or password");
        }

        TokenResponse newToken = tokenService.refreshToken(user.getId());
        user.setToken(newToken.token());
        return userMapper.toResponse(userRepository.save(user));
    }

    @Transactional
    public void logout(String authorizationHeader) {
        String tokenValue = extractBearerToken(authorizationHeader);
        Token token = tokenService.findByValue(tokenValue);

        tokenService.expireToken(tokenValue);

        User user = userService.findById(token.getUserId());
        user.setToken(null);
        userRepository.save(user);
    }

    @Transactional
    public void forgotPassword(ForgotPasswordRequest request) {
        userService.validateEmailFormat(request.email());

        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new ResourceNotFoundException("No account found with email: " + request.email()));

        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
        TokenResponse token = tokenService.createToken(user.getId(), expiredAt);
        emailService.sendPasswordResetEmail(request.email(), token.token());
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        if (!request.newPassword().equals(request.confirmPassword())) {
            throw new IllegalArgumentException("Passwords do not match");
        }

        Token token = tokenService.findByValue(request.token());
        assertTokenNotExpired(token);

        User user = userService.findById(token.getUserId());
        user.setPassword(PASSWORD_ENCODER.encode(request.newPassword()));
        userRepository.save(user);

        tokenService.expireToken(request.token());
    }

    @Transactional
    public void sendVerificationEmail(VerifyEmailRequest request) {
        userService.validateEmailFormat(request.email());

        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new ResourceNotFoundException("No account found with email: " + request.email()));

        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);
        TokenResponse token = tokenService.createToken(user.getId(), expiredAt);
        emailService.sendVerificationEmail(request.email(), token.token());
    }

    @Transactional
    public void verifyAccount(String tokenValue) {
        Token token = tokenService.findByValue(tokenValue);
        assertTokenNotExpired(token);

        User user = userService.findById(token.getUserId());
        user.setIsVerified(true);
        userRepository.save(user);

        tokenService.expireToken(tokenValue);
    }

    private void assertTokenNotExpired(Token token) {
        if (token.getExpiredAt() != null && token.getExpiredAt().isBefore(LocalDateTime.now())) {
            throw new TokenExpiredException("Token has expired");
        }
    }

    private String extractBearerToken(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new IllegalArgumentException("Authorization header must start with 'Bearer '");
        }
        return authorizationHeader.substring(7);
    }
}
