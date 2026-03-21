package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.request.ChatMessageWS;
import com.ump.studentgrab.application.mapper.ChatMapper;
import com.ump.studentgrab.domain.model.Message;
import com.ump.studentgrab.domain.repository.ChatRepository;
import com.ump.studentgrab.domain.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.stream.Collectors;

@Slf4j
@Component
@RequiredArgsConstructor
public class MessageBuffer {

    /** Flush to DB after this many messages to balance write frequency vs. memory usage. */
    private static final int FLUSH_THRESHOLD = 5;

    private final MessageRepository messageRepository;
    private final ChatRepository chatRepository;
    private final ChatMapper chatMapper;

    private final Queue<Message> queue = new ConcurrentLinkedQueue<>();

    public synchronized void add(ChatMessageWS messageWS) {
        queue.add(chatMapper.toEntity(messageWS));
        log.debug("Message buffered for chatId={}, queue size={}", messageWS.getChatId(), queue.size());

        if (queue.size() >= FLUSH_THRESHOLD) {
            flush();
        }
    }

    @Scheduled(fixedDelay = 5000)
    public synchronized void scheduledFlush() {
        if (!queue.isEmpty()) {
            flush();
        }
    }

    private void flush() {
        List<Message> batch = new ArrayList<>();
        Message msg;
        while ((msg = queue.poll()) != null) {
            batch.add(msg);
        }
        log.info("Flushing {} buffered messages to DB", batch.size());
        try {
            messageRepository.saveAll(batch);
        } catch (Exception e) {
            log.error("Failed to flush {} messages, re-queuing", batch.size(), e);
            queue.addAll(batch);
            throw e;
        }
        updateChatTimestamps(batch);
    }

    private void updateChatTimestamps(List<Message> messages) {
        Set<Long> chatIds = messages.stream()
                .map(Message::getChatId)
                .collect(Collectors.toSet());
        for (Long chatId : chatIds) {
            chatRepository.findById(chatId).ifPresent(chat -> {
                // Trigger @PreUpdate to set modifiedAt automatically
                chatRepository.save(chat);
            });
        }
    }
}
