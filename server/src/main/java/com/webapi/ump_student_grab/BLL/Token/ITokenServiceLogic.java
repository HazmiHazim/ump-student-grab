package com.webapi.ump_student_grab.BLL.Token;

import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface ITokenServiceLogic {
    CompletableFuture<TokenDTO> createToken(Long userId, LocalDateTime expiredAt);
    CompletableFuture<TokenDTO> getTokenById(Long id);
    CompletableFuture<TokenDTO> getTokenByToken(String token);
    CompletableFuture<List<TokenDTO>> getAllTokens();
    CompletableFuture<TokenDTO> expireToken(String token);
    CompletableFuture<TokenDTO> refreshToken(Long userId);
}
