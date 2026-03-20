package com.ump.studentgrab.domain.repository;

import com.ump.studentgrab.domain.model.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AttachmentRepository extends JpaRepository<Attachment, Long> {
}
