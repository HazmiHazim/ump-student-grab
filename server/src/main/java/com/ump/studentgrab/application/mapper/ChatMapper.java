package com.ump.studentgrab.application.mapper;

import com.ump.studentgrab.application.dto.request.ChatMessageWS;
import com.ump.studentgrab.application.dto.request.CreateChatRequest;
import com.ump.studentgrab.application.dto.request.CreateMessageRequest;
import com.ump.studentgrab.application.dto.response.ChatResponse;
import com.ump.studentgrab.application.dto.response.MessageResponse;
import com.ump.studentgrab.domain.model.Chat;
import com.ump.studentgrab.domain.model.Message;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ChatMapper {

    ChatResponse toResponse(Chat chat);

    Chat toEntity(CreateChatRequest request);

    List<ChatResponse> toResponseList(List<Chat> chats);

    Message toEntity(CreateMessageRequest request);

    MessageResponse toMessageResponse(Message message);

    List<MessageResponse> toMessageResponseList(List<Message> messages);

    @Mapping(source = "senderId", target = "userId")
    Message toEntity(ChatMessageWS messageWS);
}
