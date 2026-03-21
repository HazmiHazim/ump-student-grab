import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';

class ChatRoomModel {
  final int chatId;
  final int senderId;
  final String senderName;
  final int recipientId;
  final String recipientName;
  final String lastMessage;

  const ChatRoomModel({
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    required this.lastMessage,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatId: json['chatId'] as int,
      senderId: json['senderId'] as int,
      senderName: json['senderFullName'] as String? ?? '',
      recipientId: json['recipientId'] as int,
      recipientName: json['recipientFullName'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
    );
  }

  ChatRoom toEntity() => ChatRoom(
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        recipientId: recipientId,
        recipientName: recipientName,
        lastMessage: lastMessage,
      );
}
