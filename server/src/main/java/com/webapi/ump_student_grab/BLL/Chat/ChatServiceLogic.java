package com.webapi.ump_student_grab.BLL.Chat;

import com.webapi.ump_student_grab.DLL.Chat.IChatRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.ChatDTO.*;
import com.webapi.ump_student_grab.Mapper.ChatMapper;
import com.webapi.ump_student_grab.Model.Entity.Chat;
import com.webapi.ump_student_grab.Model.Entity.Message;
import com.webapi.ump_student_grab.Model.Entity.User;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

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
    public CompletableFuture<List<ChatDTO>> getAllChats() {
        return _repo.getAllChats().thenApply(_mapper::chatListToChatDTOList);
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
    public CompletableFuture<List<MessageDTO>> getAllMessages(Long chatId, Long userId, Long participantId) {
        return _repo.getAllMessages(chatId, userId, participantId).thenApply(_mapper::messageListToMessageDTOList);
    }

    @Override
    public CompletableFuture<List<ChatDetailsDTO>> getAllChatsWithDetails(Long userId) {
        // Get all chats asynchronously from the repository
        return _repo.getAllChats().thenCompose(chats -> {
            if (chats == null || chats.isEmpty()) {
                return CompletableFuture.completedFuture(new ArrayList<ChatDetailsDTO>());  // Return empty list if no chats
            }

            // Filter chats where the user is either the sender or the recipient
            List<Chat> filteredChats = chats.stream()
                    .filter(chat -> chat.getSenderId().equals(userId) || chat.getRecipientId().equals(userId))
                    .toList();

            // List to store all CompletableFutures for chat details
            List<CompletableFuture<ChatDetailsDTO>> futureChatDetailsList = filteredChats.stream().map(chat -> {
                // Fetch recipient and last message asynchronously
                CompletableFuture<User> recipientFuture = _uRepo.getUserById(chat.getRecipientId());
                CompletableFuture<User> senderFuture = _uRepo.getUserById(chat.getSenderId());
                CompletableFuture<Message> lastMessageFuture = _repo.getLastMessage(chat.getId());

                CompletableFuture<Void> all = CompletableFuture.allOf(senderFuture, recipientFuture, lastMessageFuture);


                return all.thenApply(v -> {
                    User sender = senderFuture.join();       // join is safe here since `allOf` ensures completion
                    User recipient = recipientFuture.join();
                    Message lastMessage = lastMessageFuture.join();

                    return _mapper.chatToChatDetailsDTO(
                            chat.getId(),
                            chat.getSenderId(),
                            sender.getFullName(),
                            chat.getRecipientId(),
                            recipient.getFullName(),
                            lastMessage.getContent()
                    );
                });
            }).toList();

            // Wait for all futures to complete and return the final list of DTOs
            return CompletableFuture.allOf(futureChatDetailsList.toArray(new CompletableFuture[0]))
                    .thenApply(v -> futureChatDetailsList.stream()
                            .map(CompletableFuture::join)  // Join each CompletableFuture to get the result
                            .collect(Collectors.toList()));  // Collect the results in a list
        });
    }
}
