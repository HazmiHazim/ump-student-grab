package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.TokenDTO.TokenDTO;
import com.webapi.ump_student_grab.Model.Token;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TokenMapper {

    TokenMapper INSTANCE = Mappers.getMapper(TokenMapper.class);

    TokenDTO tokenToTokenDTO(Token token);
    List<TokenDTO> tokenListToTokenDTOList(List<Token> tokens);
}
