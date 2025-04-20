package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.AttachmentDTO.AttachmentDTO;
import com.webapi.ump_student_grab.Model.Entity.Attachment;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface AttachmentMapper {

    AttachmentMapper INSTANCE = Mappers.getMapper(AttachmentMapper.class);

    AttachmentDTO attachmentToAttachmentDTO(Attachment attachment);
}
