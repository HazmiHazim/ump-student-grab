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

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatId: json['chatId'] as int,
      senderId: json['senderId'] as int,
      senderName: json['senderFullName'] as String? ?? '',
      recipientId: json['recipientId'] as int,
      recipientName: json['recipientFullName'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
    );
  }
}
