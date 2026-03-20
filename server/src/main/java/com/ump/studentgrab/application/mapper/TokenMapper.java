package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.response.TokenResponse;
import com.ump.studentgrab.domain.model.Token;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TokenMapper {

    TokenResponse toResponse(Token token);

    List<TokenResponse> toResponseList(List<Token> tokens);
}
