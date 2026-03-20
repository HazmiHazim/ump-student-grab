package com.ump.studentgrab.application.port;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface FileStorageService {

    String store(MultipartFile file);

    Resource load(String filePath);

    void delete(String filePath);
}
