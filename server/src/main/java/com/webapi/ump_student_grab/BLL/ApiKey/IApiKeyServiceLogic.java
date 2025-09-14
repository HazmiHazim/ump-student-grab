package com.webapi.ump_student_grab.BLL.ApiKey;

import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyCreateDTO;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyDTO;
import com.webapi.ump_student_grab.Model.Entity.ApiKey;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IApiKeyServiceLogic {
    CompletableFuture<ApiKeyCreateDTO> generateApiKey(String secretKey, Long userId);
    CompletableFuture<Boolean> checkApiKey(String key);
    CompletableFuture<List<ApiKeyDTO>> getAllApiKeys(String secretKey);
}
