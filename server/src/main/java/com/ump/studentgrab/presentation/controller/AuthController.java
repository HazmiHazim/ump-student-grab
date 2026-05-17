package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.request.*;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.application.service.AuthService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserResponse>> register(@Valid @RequestBody RegisterRequest request) {
        UserResponse user = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Passenger registered successfully", user));
    }

    @PostMapping("/register/driver")
    public ResponseEntity<ApiResponse<UserResponse>> registerDriver(@Valid @RequestBody DriverRegisterRequest request) {
        UserResponse user = authService.registerDriver(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Driver registered successfully", user));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserResponse>> login(@Valid @RequestBody LoginRequest request) {
        UserResponse user = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", user));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(@RequestHeader("Authorization") String authHeader) {
        authService.logout(authHeader);
        return ResponseEntity.ok(ApiResponse.success("Logout successful", null));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<ApiResponse<Void>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        authService.forgotPassword(request);
        return ResponseEntity.ok(ApiResponse.success("Password reset link sent to your email", null));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<Void>> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request);
        return ResponseEntity.ok(ApiResponse.success("Password reset successfully", null));
    }

    @PostMapping("/verify-email")
    public ResponseEntity<ApiResponse<Void>> sendVerificationEmail(@Valid @RequestBody VerifyEmailRequest request) {
        authService.sendVerificationEmail(request);
        return ResponseEntity.ok(ApiResponse.success("Verification email sent", null));
    }

    @GetMapping("/verify")
    public ResponseEntity<ApiResponse<Void>> verifyAccount(@RequestParam String token) {
        authService.verifyAccount(token);
        return ResponseEntity.ok(ApiResponse.success("Account verified successfully", null));
    }
}
