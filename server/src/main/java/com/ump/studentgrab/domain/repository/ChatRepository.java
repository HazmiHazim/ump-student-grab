package com.ump.studentgrab.domain.repository;

import com.ump.studentgrab.domain.model.Chat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ChatRepository extends JpaRepository<Chat, Long> {

    @Query("SELECT c FROM Chat c WHERE (c.senderId = :senderId AND c.recipientId = :recipientId) OR (c.senderId = :recipientId AND c.recipientId = :senderId)")
    Optional<Chat> findByParticipants(@Param("senderId") Long senderId, @Param("recipientId") Long recipientId);

    @Query("SELECT c FROM Chat c WHERE c.senderId = :userId OR c.recipientId = :userId ORDER BY c.modifiedAt DESC")
    List<Chat> findByUserId(@Param("userId") Long userId);
}
