package com.webapi.ump_student_grab.DTO.AttachmentDTO;

import java.time.LocalDateTime;

public class AttachmentDTO {

    private Long id;
    private String fileName;
    private Long fileSize;
    private String fileType;
    private String filePath;
    private Long uploadedBy;
    private LocalDateTime createdAt;

    public AttachmentDTO(Long id, String fileName, Long fileSize, String fileType, String filePath, Long uploadedBy, LocalDateTime createdAt) {
        this.id = id;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.filePath = filePath;
        this.uploadedBy = uploadedBy;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public String getFileName() {
        return fileName;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public String getFilePath() {
        return filePath;
    }

    public Long getUploadedBy() {
        return uploadedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
