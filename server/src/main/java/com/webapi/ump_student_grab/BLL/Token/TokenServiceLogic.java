package com.webapi.ump_student_grab.BLL.Token;

import com.webapi.ump_student_grab.DLL.Token.ITokenRepository;
import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;
import com.webapi.ump_student_grab.Mapper.TokenMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class TokenServiceLogic implements ITokenServiceLogic{

    private final ITokenRepository _repo;
    private final TokenMapper _mapper;

    public TokenServiceLogic(ITokenRepository repo, TokenMapper mapper) {
        this._repo = repo;
        this._mapper = mapper;
    }

    @Override
    public CompletableFuture<TokenDTO> getTokenById(Long id) {
        // Get the data from repository and map token model to TokenDTO
        return  _repo.getTokenById(id).thenApply(_mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<TokenDTO> getTokenByToken(String token) {
        // Get the data from repository and map token model to TokenDTO
        return _repo.getTokenByToken(token).thenApply(_mapper::tokenToTokenDTO);
    }

    @Override
    public CompletableFuture<List<TokenDTO>> getAllTokens() {
        return _repo.getAllTokens().thenApply(_mapper::tokenListToTokenDTOList);
    }
}
