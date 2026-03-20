package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.response.AttachmentResponse;
import com.ump.studentgrab.domain.model.Attachment;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AttachmentMapper {

    AttachmentResponse toResponse(Attachment attachment);
}
