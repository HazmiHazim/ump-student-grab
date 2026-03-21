package com.ump.studentgrab.application.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ResetPasswordRequest(
        @NotBlank(message = "New password is required") @Size(min = 6) String newPassword,
        @NotBlank(message = "Confirm password is required") String confirmPassword,
        @NotBlank(message = "Token is required") String token
) {}
