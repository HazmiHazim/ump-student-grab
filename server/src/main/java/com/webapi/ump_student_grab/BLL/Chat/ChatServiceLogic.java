package com.webapi.ump_student_grab.BLL.Chat;

import com.webapi.ump_student_grab.DLL.Chat.IChatRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.ChatDTO.ChatCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.ChatDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageCreateDTO;
import com.webapi.ump_student_grab.DTO.ChatDTO.MessageDTO;
import com.webapi.ump_student_grab.Mapper.ChatMapper;
import com.webapi.ump_student_grab.Model.Chat;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class ChatServiceLogic implements IChatServiceLogic{

    private IChatRepository _repo;
    private ChatMapper _mapper;
    private IUserRepository _uRepo;

    public ChatServiceLogic(IChatRepository repo, ChatMapper mapper, IUserRepository uRepo) {
        this._repo = repo;
        this._mapper = mapper;
        this._uRepo = uRepo;
    }

    @Override
    public CompletableFuture<ChatDTO> createChat(ChatCreateDTO chatCreateDTO) {
        return _repo.getChatByParticipant(chatCreateDTO.getSenderId(), chatCreateDTO.getRecipientId())
                .thenCompose(existingChat -> {
                    if (existingChat != null) {
                        return CompletableFuture.completedFuture(null);
                    }

                    return _uRepo.getUserById(chatCreateDTO.getSenderId()).thenCompose(user1 -> {
                        if (user1 == null) {
                            return CompletableFuture.completedFuture(null);
                        }

                        return _uRepo.getUserById(chatCreateDTO.getRecipientId()).thenCompose(user2 -> {
                            if (user2 == null) {
                                return CompletableFuture.completedFuture(null);
                            }

                            // Map ChatCreateDTO to Chat entity
                            Chat chat = _mapper.chatCreateDTOToChat(chatCreateDTO);

                            // Create chat and map the created chat entity to ChatDTO
                            return _repo.createChat(chat).thenApply(_mapper::chatToChatDTO);
                        });
                    });
                });
    }

    @Override
    public CompletableFuture<ChatDTO> getChatById(Long id) {
        return _repo.getChatById(id).thenApply(_mapper::chatToChatDTO);
    }

    @Override
    public CompletableFuture<ChatDTO> getChatByParticipant(Long senderId, Long recipientId) {
        return _repo.getChatByParticipant(senderId, recipientId).thenApply(_mapper::chatToChatDTO);
    }

    @Override
    public CompletableFuture<Integer> createMessage(MessageCreateDTO messageCreateDTO) {
        return _uRepo.getUserById(messageCreateDTO.getUserId()).thenCompose(user -> {
            if (user == null) {
                return CompletableFuture.completedFuture(1);
            }

            return _repo.getChatById(messageCreateDTO.getChatId()).thenCompose(chat -> {
                if (chat == null) {
                    return CompletableFuture.completedFuture(2);
                }

                return _repo.createMessage(_mapper.messageDTOToMessage(messageCreateDTO)).thenApply(v -> 0);
            });
        });
    }

    @Override
    public CompletableFuture<List<MessageDTO>> getAllMessages(Long userId, Long chatId) {
        return _repo.getAllMessages(userId, chatId).thenApply(_mapper::messageListToMessageDTOList);
    }
}
