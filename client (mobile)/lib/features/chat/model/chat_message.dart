class ChatMessage {
  final int? id;
  final int userId;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromRestJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  factory ChatMessage.fromWebSocketJson(Map<String, dynamic> json) {
    return ChatMessage(
      userId: json['senderId'] as int,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
