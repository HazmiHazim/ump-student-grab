package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.response.ApiKeyResponse;
import com.ump.studentgrab.application.service.ApiKeyService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/keys")
@RequiredArgsConstructor
public class ApiKeyController {

    private final ApiKeyService apiKeyService;

    @PostMapping
    public ResponseEntity<ApiResponse<ApiKeyResponse>> generateApiKey(
            @RequestParam String secretKey,
            @RequestParam Long userId) {
        ApiKeyResponse response = apiKeyService.generateApiKey(secretKey, userId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("API key generated successfully", response));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ApiKeyResponse>>> getAllApiKeys(@RequestParam String secretKey) {
        return ResponseEntity.ok(ApiResponse.success(apiKeyService.getAllApiKeys(secretKey)));
    }
}
