package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.ChatDTO.*;
import com.webapi.ump_student_grab.Model.Chat;
import com.webapi.ump_student_grab.Model.Message;
import com.webapi.ump_student_grab.Model.User;
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
    ChatDetailsDTO chatToChatDetailsDTO(Chat chat, String recipientFullName, String lastMessage);
}
