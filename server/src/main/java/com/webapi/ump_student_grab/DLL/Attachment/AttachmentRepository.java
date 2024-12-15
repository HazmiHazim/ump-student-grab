package com.webapi.ump_student_grab.DLL.Attachment;

import com.webapi.ump_student_grab.Model.Attachment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.concurrent.CompletableFuture;

@Repository
public class AttachmentRepository implements IAttachmentRepository{

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<Attachment> saveFile(Attachment attachment) {
        entityManager.persist(attachment);
        entityManager.flush();
        return CompletableFuture.completedFuture(attachment);
    }

    @Override
    @Async
    public CompletableFuture<Attachment> getFileById(Long id) {
        Attachment attachment = entityManager.find(Attachment.class, id);
        return CompletableFuture.completedFuture(attachment);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<Void> deleteFile(Long id) {
        Attachment attachment = entityManager.find(Attachment.class, id);
        if (attachment != null) {
            entityManager.remove(attachment);
        }

        return CompletableFuture.completedFuture(null);
    }
}
