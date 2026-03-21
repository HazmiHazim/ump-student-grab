package com.ump.studentgrab.domain.repository;

import com.ump.studentgrab.domain.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MessageRepository extends JpaRepository<Message, Long> {

    @Query("SELECT m FROM Message m WHERE m.chatId = :chatId AND (m.userId = :userId OR m.userId = :participantId) ORDER BY m.createdAt ASC")
    List<Message> findByChatAndParticipants(
            @Param("chatId") Long chatId,
            @Param("userId") Long userId,
            @Param("participantId") Long participantId
    );

    Optional<Message> findTopByChatIdOrderByCreatedAtDesc(Long chatId);
}
