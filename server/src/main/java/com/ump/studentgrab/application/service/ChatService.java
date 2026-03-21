package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.request.CreateChatRequest;
import com.ump.studentgrab.application.dto.request.CreateMessageRequest;
import com.ump.studentgrab.application.dto.response.ChatDetailsResponse;
import com.ump.studentgrab.application.dto.response.ChatResponse;
import com.ump.studentgrab.application.dto.response.MessageResponse;
import com.ump.studentgrab.application.exception.DuplicateResourceException;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.mapper.ChatMapper;
import com.ump.studentgrab.domain.model.Chat;
import com.ump.studentgrab.domain.model.Message;
import com.ump.studentgrab.domain.model.User;
import com.ump.studentgrab.domain.repository.ChatRepository;
import com.ump.studentgrab.domain.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepository;
    private final MessageRepository messageRepository;
    private final ChatMapper chatMapper;
    private final UserService userService;

    @Transactional
    public ChatResponse createChat(CreateChatRequest request) {
        chatRepository.findByParticipants(request.senderId(), request.recipientId())
                .ifPresent(existing -> {
                    throw new DuplicateResourceException("Chat already exists between these users");
                });

        userService.findById(request.senderId());
        userService.findById(request.recipientId());

        Chat chat = chatMapper.toEntity(request);
        return chatMapper.toResponse(chatRepository.save(chat));
    }

    public ChatResponse getChatById(Long id) {
        return chatMapper.toResponse(findById(id));
    }

    public ChatResponse getChatByParticipants(Long senderId, Long recipientId) {
        Chat chat = chatRepository.findByParticipants(senderId, recipientId)
                .orElseThrow(() -> new ResourceNotFoundException("Chat not found between users"));
        return chatMapper.toResponse(chat);
    }

    public List<ChatResponse> getAllChats() {
        return chatMapper.toResponseList(chatRepository.findAll());
    }

    @Transactional
    public MessageResponse createMessage(CreateMessageRequest request) {
        userService.findById(request.userId());
        findById(request.chatId());

        Message message = chatMapper.toEntity(request);
        return chatMapper.toMessageResponse(messageRepository.save(message));
    }

    public List<MessageResponse> getMessages(Long chatId, Long userId, Long participantId) {
        List<Message> messages = messageRepository.findByChatAndParticipants(chatId, userId, participantId);
        return chatMapper.toMessageResponseList(messages);
    }

    public List<ChatDetailsResponse> getChatDetailsForUser(Long userId) {
        return chatRepository.findByUserId(userId).stream()
                .map(this::buildChatDetails)
                .toList();
    }

    private Chat findById(Long id) {
        return chatRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Chat not found with id: " + id));
    }

    private ChatDetailsResponse buildChatDetails(Chat chat) {
        User sender = userService.findById(chat.getSenderId());
        User recipient = userService.findById(chat.getRecipientId());
        String lastMessage = messageRepository.findTopByChatIdOrderByCreatedAtDesc(chat.getId())
                .map(Message::getContent)
                .orElse(null);

        return new ChatDetailsResponse(
                chat.getId(),
                chat.getSenderId(),
                sender.getFullName(),
                chat.getRecipientId(),
                recipient.getFullName(),
                lastMessage
        );
    }
}
