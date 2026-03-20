package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.request.RegisterRequest;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.domain.model.User;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserResponse toResponse(User user);

    User toEntity(RegisterRequest request);

    List<UserResponse> toResponseList(List<User> users);
}
