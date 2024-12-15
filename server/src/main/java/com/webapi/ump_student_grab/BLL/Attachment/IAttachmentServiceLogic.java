package com.webapi.ump_student_grab.BLL.Attachment;

import com.webapi.ump_student_grab.DTO.AttachmentDTO.AttachmentDTO;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.util.concurrent.CompletableFuture;

public interface IAttachmentServiceLogic {
    CompletableFuture<AttachmentDTO> saveFile(MultipartFile file, Long userId);
    CompletableFuture<Resource> getFileById(Long id);
    CompletableFuture<Boolean> deleteFile(Long id);
}
