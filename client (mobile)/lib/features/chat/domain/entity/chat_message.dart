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
}
