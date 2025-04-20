package com.webapi.ump_student_grab.DLL.User;

import com.webapi.ump_student_grab.Model.Entity.User;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface IUserRepository {
    CompletableFuture<User> createUser(User user);
    CompletableFuture<User> getUserById(Long id);
    CompletableFuture<User> getUserByEmail(String email);
    CompletableFuture<List<User>> getAllUsers();
    CompletableFuture<User> updateUser(User user);
    CompletableFuture<Void> deleteUser(Long id);
}
