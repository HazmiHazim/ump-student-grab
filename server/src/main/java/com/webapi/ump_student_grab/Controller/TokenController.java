package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Token.ITokenServiceLogic;
import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;
import com.webapi.ump_student_grab.Model.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/tokens")
public class TokenController {

    private final ITokenServiceLogic service;

    public TokenController(ITokenServiceLogic service) {
        this.service = service;
    }

    @GetMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<TokenDTO>>> getTokenById(@PathVariable Long id) {
        return service.getTokenById(id).thenApply(token -> {
            ApiResponse<TokenDTO> response;
            HttpStatus status;
            String message;

            if (token == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Token not found.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Token found.";
                response = new ApiResponse<>(status.value(), token, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/token/{token}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<TokenDTO>>> getTokenByToken(@PathVariable String token) {
        return service.getTokenByToken(token).thenApply(existingToken -> {
            ApiResponse<TokenDTO> response;
            HttpStatus status;
            String message;

            if (existingToken == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Token not found.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Token found.";
                response = new ApiResponse<>(status.value(), existingToken, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<TokenDTO>>>> getAllTokens() {
        return service.getAllTokens().thenApply(tokens -> {
            ApiResponse<List<TokenDTO>> response;
            HttpStatus status;
            String message;

            if (tokens == null) {
                status = HttpStatus.NOT_FOUND;
                message = "No data found in record.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Tokens found.";
                response = new ApiResponse<>(status.value(), tokens, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

}
