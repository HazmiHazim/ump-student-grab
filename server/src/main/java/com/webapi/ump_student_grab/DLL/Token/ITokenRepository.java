package com.webapi.ump_student_grab.DLL.Token;

import com.webapi.ump_student_grab.Model.Token;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface ITokenRepository {
    CompletableFuture<Token> createToken(Token token);
    CompletableFuture<Token> getTokenById(Long id);
    CompletableFuture<Token> getTokenByToken(String token);
    CompletableFuture<List<Token>> getAllTokens();
    CompletableFuture<Token> updateToken(Token token);
}
