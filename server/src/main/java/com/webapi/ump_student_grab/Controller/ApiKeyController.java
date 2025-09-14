package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.ApiKey.IApiKeyServiceLogic;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyCreateDTO;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyDTO;
import com.webapi.ump_student_grab.Model.Entity.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/keys")
public class ApiKeyController {

    private final IApiKeyServiceLogic service;

    public ApiKeyController(IApiKeyServiceLogic service) {
        this.service = service;
    }

    @PostMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<ApiKeyCreateDTO>>> generateApiKey(String secretKey, Long userId) {
        return service.generateApiKey(secretKey, userId).thenApply(apiKey -> {
            ApiResponse<ApiKeyCreateDTO> response;
            HttpStatus status;
            String message;

            if (apiKey == null) {
                status = HttpStatus.UNAUTHORIZED;
                message = "You are not authorized to create an API key.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.CREATED;
                message = "API key created successfully. Please store this key securely, as it will not be shown again.";
                response = new ApiResponse<>(status.value(), apiKey, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping()
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<ApiKeyDTO>>>> getAllApiKeys(String secretKey) {
        return service.getAllApiKeys(secretKey).thenApply(keys -> {
            ApiResponse<List<ApiKeyDTO>> response;
            HttpStatus status;
            String message;

            if (keys == null) {
                status = HttpStatus.UNAUTHORIZED;
                message = "Access denied. Invalid or missing secret key.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "API keys retrieved successfully.";
                response = new ApiResponse<>(status.value(), keys, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }
}
