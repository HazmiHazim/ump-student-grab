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
import java.util.Queue;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.stream.Collectors;

@Service
public class ChatServiceLogic implements IChatServiceLogic{

    private final IChatRepository repo;
    private final ChatMapper mapper;
    private final IUserRepository uRepo;
    private final Queue<Message> messageQueue;
    private long lastFlushTime;

    public ChatServiceLogic(IChatRepository repo, ChatMapper mapper, IUserRepository uRepo) {
        this.repo = repo;
        this.mapper = mapper;
        this.uRepo = uRepo;
        this.messageQueue = new ConcurrentLinkedQueue<>();
        this.lastFlushTime = System.currentTimeMillis();
    }

    @Override
    public CompletableFuture<ChatDTO> createChat(ChatCreateDTO chatCreateDTO) {
        return repo.getChatByParticipant(chatCreateDTO.getSenderId(), chatCreateDTO.getRecipientId())
                .thenCompose(existingChat -> {
                    if (existingChat != null) {
                        return CompletableFuture.completedFuture(null);
                    }

                    return uRepo.getUserById(chatCreateDTO.getSenderId()).thenCompose(user1 -> {
                        if (user1 == null) {
                            return CompletableFuture.completedFuture(null);
                        }

                        return uRepo.getUserById(chatCreateDTO.getRecipientId()).thenCompose(user2 -> {
                            if (user2 == null) {
                                return CompletableFuture.completedFuture(null);
                            }

                            // Map ChatCreateDTO to Chat entity
                            Chat chat = mapper.chatCreateDTOToChat(chatCreateDTO);

                            // Create chat and map the created chat entity to ChatDTO
                            return repo.createChat(chat).thenApply(mapper::chatToChatDTO);
                        });
                    });
                });
    }

    @Override
    public CompletableFuture<ChatDTO> getChatById(Long id) {
        return repo.getChatById(id).thenApply(mapper::chatToChatDTO);
    }

    @Override
    public CompletableFuture<ChatDTO> getChatByParticipant(Long senderId, Long recipientId) {
        return repo.getChatByParticipant(senderId, recipientId).thenApply(mapper::chatToChatDTO);
    }

    @Override
    public CompletableFuture<List<ChatDTO>> getAllChats() {
        return repo.getAllChats().thenApply(mapper::chatListToChatDTOList);
    }

    @Override
    public CompletableFuture<Integer> createMessage(MessageCreateDTO messageCreateDTO) {
        return uRepo.getUserById(messageCreateDTO.getUserId()).thenCompose(user -> {
            if (user == null) {
                return CompletableFuture.completedFuture(1);
            }

            return repo.getChatById(messageCreateDTO.getChatId()).thenCompose(chat -> {
                if (chat == null) {
                    return CompletableFuture.completedFuture(2);
                }

                return repo.createMessage(mapper.messageDTOToMessage(messageCreateDTO)).thenApply(v -> 0);
            });
        });
    }

    @Override
    public CompletableFuture<List<MessageDTO>> getAllMessages(Long chatId, Long userId, Long participantId) {
        return repo.getAllMessages(chatId, userId, participantId).thenApply(mapper::messageListToMessageDTOList);
    }

    @Override
    public CompletableFuture<List<ChatDetailsDTO>> getAllChatsWithDetails(Long userId) {
        // Get all chats asynchronously from the repository
        return repo.getAllChats().thenCompose(chats -> {
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
                CompletableFuture<User> recipientFuture = uRepo.getUserById(chat.getRecipientId());
                CompletableFuture<User> senderFuture = uRepo.getUserById(chat.getSenderId());
                CompletableFuture<Message> lastMessageFuture = repo.getLastMessage(chat.getId());

                CompletableFuture<Void> all = CompletableFuture.allOf(senderFuture, recipientFuture, lastMessageFuture);


                return all.thenApply(v -> {
                    User sender = senderFuture.join();       // join is safe here since `allOf` ensures completion
                    User recipient = recipientFuture.join();
                    Message lastMessage = lastMessageFuture.join();

                    return mapper.chatToChatDetailsDTO(
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

    // Use synchronized because only one thread at a time can execute this method on the same instance of this class.
    public synchronized void messageBuffer(MessageWS messageWS) {
        Message message = mapper.messageWSToMessage(messageWS);
        messageQueue.add(message);

        // Get current time
        long currentTime = System.currentTimeMillis();
        long timeSinceLastFlush = currentTime - lastFlushTime;

        int MAX_SIZE_MESSAGE_BUFFER = 5;
        if (messageQueue.size() >= MAX_SIZE_MESSAGE_BUFFER || timeSinceLastFlush >= 5000) {
            List<Message> messageList = new ArrayList<>(messageQueue);
            messageQueue.clear();
            lastFlushTime = currentTime; // Update flush time
            repo.batchInsertAllMessages(messageList);
        }
    }
}
