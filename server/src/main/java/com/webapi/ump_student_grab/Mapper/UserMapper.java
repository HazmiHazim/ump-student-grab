package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.UserDTO.UserCreateDTO;
import com.webapi.ump_student_grab.DTO.UserDTO.UserDTO;
import com.webapi.ump_student_grab.Model.Entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserDTO userToUserDTO(User user);
    User userCreateDTOToUser(UserCreateDTO userCreateDTO);
    List<UserDTO> userListToUserDTOList(List<User> users);
}
