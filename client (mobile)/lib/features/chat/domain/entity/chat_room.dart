class ChatRoom {
  final int chatId;
  final int senderId;
  final String senderName;
  final int recipientId;
  final String recipientName;
  final String lastMessage;

  const ChatRoom({
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    required this.lastMessage,
  });
}
