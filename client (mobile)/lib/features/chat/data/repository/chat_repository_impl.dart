import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/chat/data/datasource/chat_websocket_data_source.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_message.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;
  final ChatWebsocketDataSource _websocket;

  ChatRepositoryImpl(this._remote, this._websocket);

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async {
    try {
      final models = await _remote.getChatRooms();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Failed to load chats',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(
      int chatId, int participantId) async {
    try {
      final models = await _remote.getMessages(chatId, participantId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Failed to load messages',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<ChatMessage> subscribeToRoom(String roomId) =>
      _websocket.subscribeToRoom(roomId);

  @override
  void sendMessage(int chatId, int userId, String senderName, String content) =>
      _websocket.sendMessage(chatId, userId, senderName, content);

  @override
  void disconnectRoom() => _websocket.disconnect();
}
