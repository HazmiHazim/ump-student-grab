package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.request.ChatMessageWS;
import com.ump.studentgrab.application.mapper.ChatMapper;
import com.ump.studentgrab.domain.model.Message;
import com.ump.studentgrab.domain.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

@Component
@RequiredArgsConstructor
public class MessageBuffer {

    /** Flush to DB after this many messages to balance write frequency vs. memory usage. */
    private static final int FLUSH_THRESHOLD = 5;

    private final MessageRepository messageRepository;
    private final ChatMapper chatMapper;

    private final Queue<Message> queue = new ConcurrentLinkedQueue<>();

    public synchronized void add(ChatMessageWS messageWS) {
        queue.add(chatMapper.toEntity(messageWS));

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
        List<Message> batch = new ArrayList<>(queue);
        queue.clear();
        messageRepository.saveAll(batch);
    }
}
