package com.webapi.ump_student_grab.BLL.Auth;

import com.webapi.ump_student_grab.DTO.UserDTO.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IAuthServiceLogic {
    CompletableFuture<UserDTO> createUser(UserCreateDTO userCreateDTO, String apiKey);
    CompletableFuture<UserDTO> getUserById(Long id, String apiKey);
    CompletableFuture<UserDTO> getUserByEmail(String email, String apiKey);
    CompletableFuture<List<UserDTO>> getAllUsers(String apiKey);
    CompletableFuture<UserDTO> updateUser(Long id, UserUpdateDTO userUpdateDTO, String apiKey);
    CompletableFuture<Boolean> deleteUser(Long id, String apiKey);
    CompletableFuture<UserDTO> loginUser(AuthDTO authDTO, String apiKey);
    CompletableFuture<Boolean> logoutUser(String token, String apiKey);
    CompletableFuture<Integer> forgotPassword(ForgotPasswordDTO forgotPasswordDTO, String apiKey);
    CompletableFuture<Integer> resetPassword(UserResetPassDTO userResetPassDTO, String apiKey);
    CompletableFuture<Boolean> verifyEmail(VerifyUserDTO verifyUserDTO, String apiKey);
    CompletableFuture<Boolean> verifyUser(String token, String apiKey);
}
