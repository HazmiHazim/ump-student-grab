package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.request.DriverRegisterRequest;
import com.ump.studentgrab.application.dto.request.RegisterRequest;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.domain.enums.UserRole;
import com.ump.studentgrab.domain.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserResponse toResponse(User user);

    @Mapping(target = "password", ignore = true)
    @Mapping(target = "role", constant = "PASSENGER")
    @Mapping(target = "isVerified", constant = "false")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "token", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "modifiedAt", ignore = true)
    @Mapping(target = "attachmentId", ignore = true)
    @Mapping(target = "gender", ignore = true)
    @Mapping(target = "birthDate", ignore = true)
    @Mapping(target = "icNo", ignore = true)
    @Mapping(target = "carBrand", ignore = true)
    @Mapping(target = "carModel", ignore = true)
    @Mapping(target = "plateNo", ignore = true)
    @Mapping(target = "carColour", ignore = true)
    @Mapping(target = "licenseType", ignore = true)
    User toEntity(RegisterRequest request);

    @Mapping(target = "password", ignore = true)
    @Mapping(target = "role", constant = "DRIVER")
    @Mapping(target = "isVerified", constant = "false")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "token", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "modifiedAt", ignore = true)
    @Mapping(target = "attachmentId", ignore = true)
    @Mapping(target = "gender", ignore = true)
    @Mapping(target = "birthDate", ignore = true)
    @Mapping(target = "matricNo", ignore = true)
    User toDriverEntity(DriverRegisterRequest request);

    List<UserResponse> toResponseList(List<User> users);
}
