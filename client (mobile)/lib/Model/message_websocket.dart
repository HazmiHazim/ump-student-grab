class MessageWebsocket {
  final String id;
  final int senderId;
  final String senderName;
  final String content;
  final String messageStatus;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
  final DateTime modifiedAt;

  MessageWebsocket({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.messageStatus,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    required this.modifiedAt,
  });

  // Factory constructor to create from JSON
  factory MessageWebsocket.fromJson(Map<String, dynamic> json) {
    return MessageWebsocket(
        id: json["id"],
        senderId: json["senderId"],
        senderName: json["senderName"],
        content: json["content"],
        messageStatus: json["messageStatus"],
        messageType: json["messageType"],
        isRead: json["read"] ?? false,
        createdAt: DateTime.parse(json["createdAt"]),
        modifiedAt: DateTime.parse(json["modifiedAt"]),
    );
  }

}