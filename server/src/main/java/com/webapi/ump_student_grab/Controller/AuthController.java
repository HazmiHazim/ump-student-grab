package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Auth.IAuthServiceLogic;
import com.webapi.ump_student_grab.DTO.UserDTO.*;
import com.webapi.ump_student_grab.Model.Entity.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/users")
public class AuthController {

    private final IAuthServiceLogic service;

    public AuthController(IAuthServiceLogic service) {
        this.service = service;
    }

    @PostMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> createUser(
            @RequestBody UserCreateDTO userCreateDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        if (apiKey == null || apiKey.isBlank()) {
            ApiResponse<UserDTO> response = new ApiResponse<>(401, null, "Invalid or missing API key.");
            return CompletableFuture.completedFuture(new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED));
        }

        return service.createUser(userCreateDTO, apiKey).thenApply(createdUser -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @GetMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> getUserById(
            @PathVariable Long id,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.getUserById(id, apiKey).thenApply(user -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

    @GetMapping("/email/{email}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> getUserByEmail(
            @PathVariable String email,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.getUserByEmail(email, apiKey).thenApply(user -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @GetMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<List<UserDTO>>>> getAllUsers(
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.getAllUsers(apiKey).thenApply(users -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<List<UserDTO>> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

    @PutMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> updateUser(
            @PathVariable Long id,
            @RequestBody UserUpdateDTO userUpdateDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.updateUser(id, userUpdateDTO, apiKey).thenApply(updatedUser -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @DeleteMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> deleteUser(
            @PathVariable Long id,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.deleteUser(id, apiKey).thenApply(deletedUser -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

    @PostMapping("/login")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> loginUser(
            @RequestBody AuthDTO authDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.loginUser(authDTO, apiKey).thenApply(loginUser -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @PostMapping("/logout")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> logoutUser(
            @RequestHeader("Authorization") String authHeader,
            @RequestHeader("X-Api-Key") String apiKey) {

        // Check if the token is present and starts with "Bearer "
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return CompletableFuture.completedFuture(
                    new ResponseEntity<>(new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, "Token is missing or malformed"), HttpStatus.BAD_REQUEST)
            );
        }

        // Extract the token
        String token = authHeader.substring(7);  // Remove "Bearer " from the start
        return service.logoutUser(token, apiKey).thenApply(logoutUser -> {
            HttpStatus status;
            String message;

            if (!logoutUser) {
                status = HttpStatus.NOT_FOUND;
                message = "Token is invalid.";
            } else {
                status = HttpStatus.OK;
                message = "User logout successfully.";
            }

            ApiResponse<UserDTO> response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

    @PostMapping("/forgot-password")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> forgotPassword(
            @RequestBody ForgotPasswordDTO forgotPasswordDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.forgotPassword(forgotPasswordDTO, apiKey).thenApply(result -> {
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
                case 3 -> {
                    message = "Failed to send reset password link.";
                    yield HttpStatus.INTERNAL_SERVER_ERROR;
                }
                default -> {
                    message = "Successful sent reset link. Please check your email to reset new password.";
                    yield HttpStatus.OK;
                }
            };

            ApiResponse<UserDTO> response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @PostMapping("/reset-password")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> resetPassword(
            @RequestBody UserResetPassDTO userResetPassDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.resetPassword(userResetPassDTO, apiKey).thenApply(result -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

    @PostMapping("/verify-email")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> verifyEmail(
            @RequestBody VerifyUserDTO verifyUserDTO,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.verifyEmail(verifyUserDTO, apiKey).thenApply(result -> {
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
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.BAD_REQUEST.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        });
    }

    @PostMapping("/verify-user")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<UserDTO>>> verifyUser(
            @RequestParam String token,
            @RequestHeader("X-Api-Key") String apiKey) {

        return service.verifyUser(token, apiKey).thenApply(result -> {
            ApiResponse<UserDTO> response;
            HttpStatus status;
            String message;

            if (!result) {
                status = HttpStatus.NOT_FOUND;
                message = "Token is invalid or expired.";
            } else {
                status = HttpStatus.OK;
                message = "Your account has been verified.";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        }).exceptionally(ex -> {
            String message = ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage();
            ApiResponse<UserDTO> response = new ApiResponse<>(HttpStatus.UNAUTHORIZED.value(), null, message);
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        });
    }

}
