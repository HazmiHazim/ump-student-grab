package com.webapi.ump_student_grab.BLL.Attachment;

import com.webapi.ump_student_grab.DLL.Attachment.IAttachmentRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.AttachmentDTO.AttachmentDTO;
import com.webapi.ump_student_grab.Mapper.AttachmentMapper;
import com.webapi.ump_student_grab.Model.Attachment;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.concurrent.CompletableFuture;

@Service
public class AttachmentServiceLogic implements IAttachmentServiceLogic{

    private final IAttachmentRepository _repo;
    private final AttachmentMapper _mapper;
    private final IUserRepository _uRepo;

    public AttachmentServiceLogic(IAttachmentRepository repo, AttachmentMapper mapper, IUserRepository uRepo) {
        this._repo = repo;
        this._mapper = mapper;
        this._uRepo = uRepo;
    }

    @Override
    public CompletableFuture<AttachmentDTO> saveFile(MultipartFile file, Long userId) {
        // Extract all the metadata needed for saving in database
        String fileName = file.getOriginalFilename();
        Long fileSize = file.getSize();
        String fileType = file.getContentType();

        // Check if the file is valid (optional)
        if (fileName == null || fileSize == 0) {
            return CompletableFuture.completedFuture(null); // Or throw an exception
        }

        // Check if user exists
        return _uRepo.getUserById(userId).thenCompose(existingUser -> {
            // Check if user not exists then cannot upload
            if (existingUser == null) {
                return CompletableFuture.completedFuture(null);
            }

            String folderPath = "D:/Others/Spring Boot Assets/";
            File folder = new File(folderPath);

            // Create folder if it doesn't exist
            if (!folder.exists() && !folder.mkdirs()) {
                return CompletableFuture.completedFuture(null);
            }

            // Save file in the folder
            try (FileOutputStream os = new FileOutputStream(folderPath + fileName)) {
                // Write the content of the uploaded file to the disk
                os.write(file.getBytes());  // Write file content to the output stream
            } catch (IOException e) {
                // Handle exception
                throw new RuntimeException("Error saving file to disk: " + e.getMessage(), e);
            }

            Attachment attachment = new Attachment();
            attachment.setFileName(fileName);
            attachment.setFileSize(fileSize);
            attachment.setFileType(fileType);
            attachment.setFilePath(folderPath + fileName);
            attachment.setUploadedBy(userId);

            return  _repo.saveFile(attachment).thenApply(_mapper::attachmentToAttachmentDTO);
        });
    }

    @Override
    public CompletableFuture<Resource> getFileById(Long id) {
        // check file exists
        return _repo.getFileById(id).thenCompose(existingFile -> {
            if (existingFile == null) {
                return CompletableFuture.completedFuture(null);
            }

            // Get file from file system
            File file = new File(existingFile.getFilePath());

            // Check if the file exists on the file system
            if (!file.exists()) {
                // Handle case where the file does not exist
                return CompletableFuture.completedFuture(null);
            }

            // Wrap the file in a Resource
            FileSystemResource resource = new FileSystemResource(file);
            return CompletableFuture.completedFuture(resource);
        });
    }

    @Override
    public CompletableFuture<Boolean> deleteFile(Long id) {
        return _repo.getFileById(id).thenCompose(existingFile -> {
            if (existingFile == null) {
                return CompletableFuture.completedFuture(false);
            }

            // Get file from file system
            File file = new File(existingFile.getFilePath());

            // Check if the file exists on the file system
            if (!file.exists()) {
                // Handle case where the file does not exist
                return CompletableFuture.completedFuture(false);
            }

            // Delete file in file system
            boolean fileDeleted = file.delete();

            if (!fileDeleted) {
                // File deletion failed (e.g., file may be in use or permissions issues)
                return CompletableFuture.completedFuture(false);
            }

            return _repo.deleteFile(id).thenApply(v -> true);
        });
    }
}
