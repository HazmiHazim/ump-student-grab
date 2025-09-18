package com.webapi.ump_student_grab.BLL.Attachment;

import com.webapi.ump_student_grab.DTO.AttachmentDTO.AttachmentDTO;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.util.concurrent.CompletableFuture;

public interface IAttachmentServiceLogic {
    CompletableFuture<AttachmentDTO> saveFile(MultipartFile file, Long userId, String apiKey);
    CompletableFuture<Resource> getFileById(Long id, String apiKey);
    CompletableFuture<Boolean> deleteFile(Long id, String apiKey);
}
