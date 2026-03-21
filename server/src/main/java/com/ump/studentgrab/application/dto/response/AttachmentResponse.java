package com.ump.studentgrab.application.dto.response;

import java.time.LocalDateTime;

public record AttachmentResponse(
        Long id,
        String fileName,
        Long fileSize,
        String fileType,
        Long uploadedBy,
        LocalDateTime createdAt
) {}
