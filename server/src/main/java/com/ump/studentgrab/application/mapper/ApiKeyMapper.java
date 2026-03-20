package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.response.ApiKeyResponse;
import com.ump.studentgrab.domain.model.ApiKey;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ApiKeyMapper {

    ApiKeyResponse toResponse(ApiKey apiKey);

    List<ApiKeyResponse> toResponseList(List<ApiKey> apiKeys);
}
