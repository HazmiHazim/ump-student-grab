package com.webapi.ump_student_grab.DTO.ChatDTO;

public class MessageCreateDTO {

    private String content;
    private String attachment;
    private Long userId;
    private Long chatId;

    public MessageCreateDTO(String content, String attachment, Long userId, Long chatId) {
        this.content = content;
        this.attachment = attachment;
        this.userId = userId;
        this.chatId = chatId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getChatId() {
        return chatId;
    }

    public void setChatId(Long chatId) {
        this.chatId = chatId;
    }
}
