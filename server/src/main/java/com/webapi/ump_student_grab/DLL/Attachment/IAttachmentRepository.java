package com.webapi.ump_student_grab.DLL.Attachment;

import com.webapi.ump_student_grab.Model.Entity.Attachment;

import java.util.concurrent.CompletableFuture;

public interface IAttachmentRepository {
    CompletableFuture<Attachment> saveFile(Attachment attachment);
    CompletableFuture<Attachment> getFileById(Long id);
    CompletableFuture<Void> deleteFile(Long id);
}
