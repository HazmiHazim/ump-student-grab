package com.ump.studentgrab.application.dto.request;

public record ResetPasswordRequest(String newPassword, String confirmPassword, String token) {}
