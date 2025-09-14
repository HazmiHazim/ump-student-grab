package com.webapi.ump_student_grab.DLL.ApiKey;

import com.webapi.ump_student_grab.Model.Entity.ApiKey;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IApiKeyRepository {
    CompletableFuture<ApiKey> createApiKey(ApiKey apiKey);
    CompletableFuture<ApiKey> getApiKey(String apiKey);
    CompletableFuture<List<ApiKey>> getAllApiKeys();
}
