package com.ump.studentgrab.domain.repository;

import com.ump.studentgrab.domain.model.ApiKey;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ApiKeyRepository extends JpaRepository<ApiKey, Short> {

    Optional<ApiKey> findByApiKey(String apiKey);
}
