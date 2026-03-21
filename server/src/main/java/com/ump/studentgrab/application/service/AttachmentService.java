package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.response.AttachmentResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.mapper.AttachmentMapper;
import com.ump.studentgrab.application.port.FileStorageService;
import com.ump.studentgrab.domain.model.Attachment;
import com.ump.studentgrab.domain.repository.AttachmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class AttachmentService {

    private final AttachmentRepository attachmentRepository;
    private final AttachmentMapper attachmentMapper;
    private final UserService userService;
    private final FileStorageService fileStorageService;

    @Transactional
    public AttachmentResponse saveFile(MultipartFile file, Long userId) {
        log.info("Saving file '{}' ({}KB) for userId={}", file.getOriginalFilename(), file.getSize() / 1024, userId);
        userService.findById(userId);

        String filePath = fileStorageService.store(file);

        Attachment attachment = Attachment.builder()
                .fileName(file.getOriginalFilename())
                .fileSize(file.getSize())
                .fileType(file.getContentType())
                .filePath(filePath)
                .uploadedBy(userId)
                .build();

        AttachmentResponse response = attachmentMapper.toResponse(attachmentRepository.save(attachment));
        log.info("File saved: id={}, type={}", response.id(), file.getContentType());
        return response;
    }

    public Resource getFile(Long id) {
        Attachment attachment = findById(id);
        return fileStorageService.load(attachment.getFilePath());
    }

    @Transactional
    public void deleteFile(Long id) {
        log.info("Deleting attachment: id={}", id);
        Attachment attachment = findById(id);
        fileStorageService.delete(attachment.getFilePath());
        attachmentRepository.delete(attachment);
        log.info("Attachment deleted: id={}", id);
    }

    // Internal — returns entity for use within the application layer
    public Attachment findById(Long id) {
        return attachmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Attachment not found with id: " + id));
    }
}
