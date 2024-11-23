class ChatResponse {
  final int status;
  final int chatId;
  final int senderId;
  final int recipientId;
  final String recipientName;
  final String lastMessage;

  ChatResponse({
    required this.status,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.recipientName,
    required this.lastMessage
  });

  // Factory constructor to create from JSON
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      status: json["status"],
      chatId: json["chatId"],
      senderId: json["senderId"],
      recipientId: json["recipientId"],
      recipientName: json["recipientFullName"],
      lastMessage: json["lastMessage"],
    );
  }

}