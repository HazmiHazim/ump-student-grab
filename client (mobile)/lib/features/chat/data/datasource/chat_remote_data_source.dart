import 'package:dio/dio.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/chat/data/model/chat_message_model.dart';
import 'package:ump_student_grab_mobile/features/chat/data/model/chat_room_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getChatRooms();
  Future<List<ChatMessageModel>> getMessages(int chatId, int participantId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;
  final LocalStorage _storage;

  ChatRemoteDataSourceImpl(this._dio, this._storage);

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    final userJson = await _storage.getUser();
    if (userJson == null) throw Exception('User not authenticated');
    final userId = userJson['id'] as int;

    final response = await _dio.get(ApiEndpoints.chatsByUser(userId));
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(int chatId, int participantId) async {
    final userJson = await _storage.getUser();
    if (userJson == null) throw Exception('User not authenticated');
    final userId = userJson['id'] as int;

    final response = await _dio
        .get(ApiEndpoints.messages(chatId, userId, participantId));
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => ChatMessageModel.fromRestJson(e as Map<String, dynamic>))
        .toList();
  }
}
