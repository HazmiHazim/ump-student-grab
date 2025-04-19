package com.webapi.ump_student_grab.BLL.Token;

import com.webapi.ump_student_grab.DLL.Token.ITokenRepository;
import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;
import com.webapi.ump_student_grab.Mapper.TokenMapper;
import org.springframework.stereotype.Service;

import java.util.List;
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
    public CompletableFuture<TokenDTO> getTokenById(Long id) {
        // Get the data from repository and map token model to TokenDTO
        return repo.getTokenById(id).thenApply(mapper::tokenToTokenDTO);
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
}
