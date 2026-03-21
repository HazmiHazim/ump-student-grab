package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.request.RegisterRequest;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.domain.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserResponse toResponse(User user);

    @Mapping(target = "password", ignore = true)
    @Mapping(target = "isVerified", constant = "false")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "token", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "modifiedAt", ignore = true)
    @Mapping(target = "attachmentId", ignore = true)
    User toEntity(RegisterRequest request);

    List<UserResponse> toResponseList(List<User> users);
}
