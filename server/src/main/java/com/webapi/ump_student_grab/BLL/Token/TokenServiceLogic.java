package com.webapi.ump_student_grab.BLL.Token;

import com.webapi.ump_student_grab.DLL.Token.ITokenRepository;
import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;
import com.webapi.ump_student_grab.Mapper.TokenMapper;
import com.webapi.ump_student_grab.Model.Entity.Token;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class TokenServiceLogic implements ITokenServiceLogic{

    private final ITokenRepository repo;
    private final TokenMapper mapper;

    public TokenServiceLogic(ITokenRepository repo, TokenMapper mapper) {
        this.repo = repo;
        this.mapper = mapper;
    }

    @Override
    public CompletableFuture<TokenDTO> createToken(Long userId, LocalDateTime expiredAt) {
        if (userId == null) {
            return CompletableFuture.completedFuture(null);
        }
        // Generate a unique token (using UUID)
        String generatedToken = UUID.randomUUID().toString().replace("-", "");
        LocalDateTime now = LocalDateTime.now();
        Token token = new Token(null, generatedToken, userId, expiredAt, now, now);

        return repo.createToken(token).thenApply(mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<TokenDTO> getTokenById(Long id) {
        // Get the data from repository and map token model to TokenDTO
        return repo.getTokenById(id).thenApply(mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<TokenDTO> getTokenByUserId(Long userId) {
        // Get the data from repository and map token model to TokenDTO
        return repo.getTokenByUserId(userId).thenApply(mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<TokenDTO> getTokenByToken(String token) {
        // Get the data from repository and map token model to TokenDTO
        return repo.getTokenByToken(token).thenApply(mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<List<TokenDTO>> getAllTokens() {
        return repo.getAllTokens().thenApply(mapper::tokenListToTokenDTOList);
    }

    @Override
    public CompletableFuture<TokenDTO> expireToken(String token) {
        return repo.getTokenByToken(token).thenCompose(existingToken -> {
            if (existingToken == null) {
                return CompletableFuture.completedFuture(null);
            }

            existingToken.setExpiredAt(LocalDateTime.now());
            return repo.updateToken(existingToken).thenApply(mapper::tokenToTokenDTO);
        });
    }

    @Override
    public CompletableFuture<TokenDTO> refreshToken(Long userId) {
        return repo.getTokenByUserId(userId).thenCompose(existingToken -> {
            if (existingToken != null) {
                existingToken.setExpiredAt(LocalDateTime.now());
                return repo.updateToken(existingToken).thenCompose(updated -> createToken(userId, null)); // new token after expiring old
            }

            return createToken(userId, null);
        });
    }
}
