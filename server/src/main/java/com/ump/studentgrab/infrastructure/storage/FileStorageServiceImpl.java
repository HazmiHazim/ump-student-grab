package com.ump.studentgrab.infrastructure.storage;

import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.port.FileStorageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageServiceImpl implements FileStorageService {

    private final Path storageLocation;

    public FileStorageServiceImpl(@Value("${app.file-storage-path}") String storagePath) {
        this.storageLocation = Paths.get(storagePath).toAbsolutePath().normalize();
        try {
            Files.createDirectories(storageLocation);
        } catch (IOException e) {
            throw new RuntimeException("Could not create file storage directory: " + storagePath, e);
        }
    }

    @Override
    public String store(MultipartFile file) {
        String originalName = file.getOriginalFilename();
        if (originalName == null || originalName.isBlank() || file.getSize() == 0) {
            throw new IllegalArgumentException("Invalid file: name is empty or file has no content");
        }

        // Sanitize: use UUID prefix to prevent path traversal and name collisions
        String extension = originalName.contains(".")
                ? originalName.substring(originalName.lastIndexOf('.'))
                : "";
        String fileName = UUID.randomUUID() + extension;

        Path targetPath = storageLocation.resolve(fileName).normalize();
        if (!targetPath.startsWith(storageLocation)) {
            throw new IllegalArgumentException("Invalid file path");
        }
        try {
            Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file: " + fileName, e);
        }

        return targetPath.toString();
    }

    @Override
    public Resource load(String filePath) {
        Resource resource = new FileSystemResource(Paths.get(filePath));
        if (!resource.exists()) {
            throw new ResourceNotFoundException("File not found at path: " + filePath);
        }
        return resource;
    }

    @Override
    public void delete(String filePath) {
        try {
            Files.deleteIfExists(Paths.get(filePath));
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete file: " + filePath, e);
        }
    }
}
