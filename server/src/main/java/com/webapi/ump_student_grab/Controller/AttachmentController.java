package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Attachment.IAttachmentServiceLogic;
import com.webapi.ump_student_grab.DTO.AttachmentDTO.AttachmentDTO;
import com.webapi.ump_student_grab.Model.Entity.ApiResponse;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/attachments")
public class AttachmentController {

    private final IAttachmentServiceLogic service;

    public AttachmentController(IAttachmentServiceLogic service) {
        this.service = service;
    }

    @PostMapping("")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<AttachmentDTO>>> saveFile(@RequestParam("file")MultipartFile file, @RequestParam Long userId) {
        return service.saveFile(file, userId).thenApply(savedFile -> {
            ApiResponse<AttachmentDTO> response;
            HttpStatus status;
            String message;

            if (savedFile == null) {
                status = HttpStatus.FAILED_DEPENDENCY;
                message = "Failed to save file.";
            } else {
                status = HttpStatus.CREATED;
                message = "File saved successfully.";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }

    @GetMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<?>> getFileById(@PathVariable Long id) {
        return service.getFileById(id).thenApply(resource -> {
            if (resource == null) {
                ApiResponse<String> response = new ApiResponse<>(HttpStatus.NOT_FOUND.value(), null, "File not found.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            try {
                File file = resource.getFile();
                Path filePath = file.toPath();
                String contentType = Files.probeContentType(filePath);

                // Default content type
                if (contentType == null) {
                    contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
                }

                HttpHeaders headers = new HttpHeaders();

                headers.add(HttpHeaders.CONTENT_DISPOSITION,
                        (contentType.startsWith("image/") ? "inline" : "attachment") + "; filename=\"" + resource.getFilename() + "\"");
                headers.setContentType(MediaType.parseMediaType(contentType));

                InputStreamResource fileStream = new InputStreamResource(Files.newInputStream(filePath));

                return ResponseEntity.ok()
                        .headers(headers)
                        .contentLength(file.length()) // Ensure content length is set
                        .body(fileStream);

            } catch (IOException e) {
                ApiResponse<String> errorResponse = new ApiResponse<>(HttpStatus.INTERNAL_SERVER_ERROR.value(), null, "Error reading file.");
                return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        });
    }

    @DeleteMapping("/{id}")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<AttachmentDTO>>> deleteFile(@PathVariable Long id) {
        return service.deleteFile(id).thenApply(deletedFile -> {
            ApiResponse<AttachmentDTO> response;
            HttpStatus status;
            String message;

            if (!deletedFile) {
                status = HttpStatus.NOT_FOUND;
                message = "File not found.";
            } else {
                status = HttpStatus.OK;
                message = "File deleted successfully.";
            }

            response = new ApiResponse<>(status.value(), null, message);
            return new ResponseEntity<>(response, status);
        });
    }
}
