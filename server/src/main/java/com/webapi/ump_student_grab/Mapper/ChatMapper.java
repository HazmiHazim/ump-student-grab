package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.ChatDTO.*;
import com.webapi.ump_student_grab.Model.Entity.Chat;
import com.webapi.ump_student_grab.Model.Entity.Message;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
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
    ChatDetailsDTO chatToChatDetailsDTO(Long chatId, Long senderId, String senderFullName, Long recipientId, String recipientFullName, String lastMessage);
    @Mapping(source = "senderId", target = "userId")
    Message messageWSToMessage(MessageWS messageWS);
}
