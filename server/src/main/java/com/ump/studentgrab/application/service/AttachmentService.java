package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.response.AttachmentResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.mapper.AttachmentMapper;
import com.ump.studentgrab.application.port.FileStorageService;
import com.ump.studentgrab.domain.model.Attachment;
import com.ump.studentgrab.domain.repository.AttachmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class AttachmentService {

    private final AttachmentRepository attachmentRepository;
    private final AttachmentMapper attachmentMapper;
    private final UserService userService;
    private final FileStorageService fileStorageService;

    @Transactional
    public AttachmentResponse saveFile(MultipartFile file, Long userId) {
        userService.findById(userId);

        String filePath = fileStorageService.store(file);

        Attachment attachment = Attachment.builder()
                .fileName(file.getOriginalFilename())
                .fileSize(file.getSize())
                .fileType(file.getContentType())
                .filePath(filePath)
                .uploadedBy(userId)
                .build();

        return attachmentMapper.toResponse(attachmentRepository.save(attachment));
    }

    public Resource getFile(Long id) {
        Attachment attachment = findById(id);
        return fileStorageService.load(attachment.getFilePath());
    }

    @Transactional
    public void deleteFile(Long id) {
        Attachment attachment = findById(id);
        fileStorageService.delete(attachment.getFilePath());
        attachmentRepository.delete(attachment);
    }

    // Internal — returns entity for use within the application layer
    public Attachment findById(Long id) {
        return attachmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Attachment not found with id: " + id));
    }
}
