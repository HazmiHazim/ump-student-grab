class ChatMessage {
  final int userId;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.userId,
    required this.content,
    required this.createdAt,
  });
}
