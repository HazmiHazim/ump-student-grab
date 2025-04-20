import 'package:ump_student_grab_mobile/Model/message_response.dart';
import 'package:ump_student_grab_mobile/Model/message_websocket.dart';

class ChatMessage {
  final int userId;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromMessageResponse(MessageResponse response) {
    return ChatMessage(
      userId: response.userId,
      content: response.content,
      createdAt: response.createdAt,
    );
  }

  factory ChatMessage.fromWebSocket(MessageWebsocket ws) {
    return ChatMessage(
      userId: ws.senderId,
      content: ws.content,
      createdAt: DateTime.parse(ws.createdAt.toString()),
    );
  }
}
