package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.response.AttachmentResponse;
import com.ump.studentgrab.application.service.AttachmentService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;

@RestController
@RequestMapping("/api/attachments")
@RequiredArgsConstructor
public class AttachmentController {

    private final AttachmentService attachmentService;

    @PostMapping
    public ResponseEntity<ApiResponse<AttachmentResponse>> upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam Long userId) {
        AttachmentResponse response = attachmentService.saveFile(file, userId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("File uploaded successfully", response));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> download(@PathVariable Long id) throws IOException {
        Resource resource = attachmentService.getFile(id);

        String contentType = Files.probeContentType(resource.getFile().toPath());
        if (contentType == null) {
            contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
        }

        String disposition = contentType.startsWith("image/") ? "inline" : "attachment";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, disposition + "; filename=\"" + resource.getFilename() + "\"")
                .contentType(MediaType.parseMediaType(contentType))
                .contentLength(resource.getFile().length())
                .body(new InputStreamResource(resource.getInputStream()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        attachmentService.deleteFile(id);
        return ResponseEntity.ok(ApiResponse.success("File deleted successfully", null));
    }
}
