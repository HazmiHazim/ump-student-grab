import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_message.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatRoom>>> getChatRooms();
  Future<Either<Failure, List<ChatMessage>>> getMessages(int chatId, int participantId);
  Stream<ChatMessage> subscribeToRoom(String roomId);
  void sendMessage(int chatId, int userId, String senderName, String content);
  void disconnectRoom();
}
