import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_message.dart';

class ChatMessageModel {
  final int userId;
  final String content;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromRestJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      userId: json['userId'] as int,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory ChatMessageModel.fromWebSocketJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      userId: json['senderId'] as int,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ChatMessage toEntity() =>
      ChatMessage(userId: userId, content: content, createdAt: createdAt);
}
