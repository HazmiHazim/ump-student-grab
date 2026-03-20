package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.response.TokenResponse;
import com.ump.studentgrab.application.service.TokenService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tokens")
@RequiredArgsConstructor
public class TokenController {

    private final TokenService tokenService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<TokenResponse>>> getAllTokens() {
        return ResponseEntity.ok(ApiResponse.success(tokenService.getAllTokens()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TokenResponse>> getTokenById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(tokenService.getTokenById(id)));
    }

    @GetMapping("/value/{token}")
    public ResponseEntity<ApiResponse<TokenResponse>> getTokenByValue(@PathVariable String token) {
        return ResponseEntity.ok(ApiResponse.success(tokenService.getTokenByValue(token)));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<ApiResponse<TokenResponse>> getTokenByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(ApiResponse.success(tokenService.getTokenByUserId(userId)));
    }
}
