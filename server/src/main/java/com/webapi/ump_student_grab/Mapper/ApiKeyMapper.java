package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyCreateDTO;
import com.webapi.ump_student_grab.DTO.ApiKeyDTO.ApiKeyDTO;
import com.webapi.ump_student_grab.Model.Entity.ApiKey;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ApiKeyMapper {

    ApiKeyMapper INSTANCE = Mappers.getMapper(ApiKeyMapper.class);

    ApiKeyCreateDTO apiKeyToApiKeyCreateDTO(ApiKey apiKey);
    List<ApiKeyDTO> apiKeyListToApiKeyDTOList(List<ApiKey> apiKeys);
}
