package com.ump.studentgrab.domain.repository;

import com.ump.studentgrab.domain.model.Token;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TokenRepository extends JpaRepository<Token, Long> {

    Optional<Token> findByToken(String token);

    Optional<Token> findTopByUserIdOrderByCreatedAtDesc(Long userId);
}
