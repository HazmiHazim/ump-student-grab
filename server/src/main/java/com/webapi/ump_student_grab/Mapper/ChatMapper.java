package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.ChatDTO.ChatCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.ChatDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageDTO;
import com.webapi.ump_student_grab.Model.Chat;
import com.webapi.ump_student_grab.Model.Message;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ChatMapper {

    ChatMapper INSTANCE = Mappers.getMapper(ChatMapper.class);

    ChatDTO chatToChatDTO(Chat chat);
    Chat chatCreateDTOToChat(ChatCreateDTO chatCreateDTO);
    List<ChatDTO> chatListToChatDTOList(List<Chat> chats);
    Message messageDTOToMessage(MessageCreateDTO messageDTO);
    List<MessageDTO> messageListToMessageDTOList(List<Message> messages);
}
