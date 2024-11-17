package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Auth.IAuthServiceLogic;
import com.webapi.ump_student_grab.DTO.UserDTO.*;
import com.webapi.ump_student_grab.Model.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/users")
public class AuthController {

    private final IAuthServiceLogic _service;

    public AuthController(IAuthServiceLogic service) {
        this._service = service;
    }

    @PostMapping("/create")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> createUser(@RequestBody UserCreateDTO userCreateDTO) {
        return _service.createUser(userCreateDTO).thenApply(createdUser -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (createdUser == null) {
                status = HttpStatus.CONFLICT;
                message = "Email already taken.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.CREATED;
                message = "User created successfully.";
                response = new ApiResponse<>(status.value(), createdUser, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/getUserById/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> getUserById(@PathVariable Long id) {
        return _service.getUserById(id).thenApply(user -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (user == null) {
                status = HttpStatus.NOT_FOUND;
                message = "User not found.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "User found.";
                response = new ApiResponse<>(status.value(), user, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/getUserByEmail/{email}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> getUserByEmail(@PathVariable String email) {
        return _service.getUserByEmail(email).thenApply(user -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (user == null) {
                status = HttpStatus.NOT_FOUND;
                message = "User not found.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "User found.";
                response = new ApiResponse<>(status.value(), user, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/allUsers")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<UserDTO>>>> getAllUsers() {
        return _service.getAllUsers().thenApply(users -> {
            ApiResponse<List<UserDTO>> response;
            HttpStatus status;
            String message;

            if (users == null) {
                status = HttpStatus.NOT_FOUND;
                message = "No data found in our record.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "Users found.";
                response = new ApiResponse<>(status.value(), users, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @PutMapping("/update/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> updateUser(@PathVariable Long id, @RequestBody UserUpdateDTO userUpdateDTO) {
        return _service.updateUser(id, userUpdateDTO).thenApply(updatedUser -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (updatedUser == null) {
                status = HttpStatus.NOT_FOUND;
                message = "User not found.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "User updated successfully.";
                response = new ApiResponse<>(status.value(), updatedUser, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @DeleteMapping("/delete/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> deleteUser(@PathVariable Long id) {
        return _service.deleteUser(id).thenApply(deletedUser -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (!deletedUser) {
                status = HttpStatus.NOT_FOUND;
                message = "User not found.";
            } else {
                status = HttpStatus.OK;
                message = "User deleted successfully.";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/login")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> loginUser(@RequestBody AuthDTO authDTO) {
        return _service.loginUser(authDTO).thenApply(loginUser -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (loginUser == null) {
                status = HttpStatus.UNAUTHORIZED;
                message = "Invalid email or password.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.OK;
                message = "User login successfully.";
                response = new ApiResponse<>(status.value(), loginUser, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/forgotPassword")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> forgotPassword(@RequestParam String email) {
        return _service.forgotPassword(email).thenApply(result -> {
            String message;
            HttpStatus status = switch (result) {
                case 1 -> {
                    message = "Email does not exists in our records.";
                    yield HttpStatus.NOT_FOUND;
                }
                case 2 -> {
                    message = "Failed created token.";
                    yield HttpStatus.PRECONDITION_FAILED;
                }
                default -> {
                    message = "Successful sent reset link. Please check your email to reset new password.";
                    yield HttpStatus.CREATED;
                }
            };

            ApiResponse<UserDTO> response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/resetPassword")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> resetPassword(@RequestBody UserResetPassDTO userResetPassDTO) {
        return _service.resetPassword(userResetPassDTO).thenApply(result -> {
            String message;
            HttpStatus status = switch (result) {
                case 1 -> {
                    message = "Token is invalid or expired.";
                    yield HttpStatus.BAD_REQUEST;
                }
                case 2 -> {
                    message = "User not found.";
                    yield HttpStatus.NOT_FOUND;
                }
                case 3 -> {
                    message = "Confirm password is incorrect.";
                    yield HttpStatus.BAD_REQUEST;
                }
                default -> {
                    message = "Successfully reset password.";
                    yield HttpStatus.OK;
                }
            };

            ApiResponse<UserDTO> response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/verifyEmail")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> verifyEmail(@RequestParam String email) {
        return _service.verifyEmail(email).thenApply(result -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (!result) {
                status = HttpStatus.NOT_FOUND;
                message = "Email does not exists in our records.";
            } else {
                status = HttpStatus.OK;
                message = "Successful sent verification link. Please check your email to verify your account.";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @PostMapping("/verifyUser/{token}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> verifyUser(@PathVariable String token) {
        return _service.verifyUser(token).thenApply(result -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (!result) {
                status = HttpStatus.NOT_FOUND;
                message = "Token is invalid or expired.";
            } else {
                status = HttpStatus.OK;
                message = "http://127.0.0.1/verificationSuccessPage";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

}
