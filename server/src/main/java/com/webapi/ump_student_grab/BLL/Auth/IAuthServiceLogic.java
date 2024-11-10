package com.webapi.ump_student_grab.BLL.Auth;

import com.webapi.ump_student_grab.DTO.UserDTO.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IAuthServiceLogic {
    CompletableFuture<UserDTO> createUser(UserCreateDTO userCreateDTO);
    CompletableFuture<UserDTO> getUserById(Long id);
    CompletableFuture<UserDTO> getUserByEmail(String email);
    CompletableFuture<List<UserDTO>> getAllUsers();
    CompletableFuture<UserDTO> updateUser(Long id, UserUpdateDTO userUpdateDTO);
    CompletableFuture<Boolean> deleteUser(Long id);
    CompletableFuture<Boolean> loginUser(AuthDTO authDTO);
    CompletableFuture<Integer> forgotPassword(String email);
    CompletableFuture<Integer> resetPassword(UserResetPassDTO userResetPassDTO);
    CompletableFuture<Boolean> verifyEmail(String email);
    CompletableFuture<Boolean> verifyUser(String token);
}
