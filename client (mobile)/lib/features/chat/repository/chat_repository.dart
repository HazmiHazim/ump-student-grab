import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_message.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_room.dart';

class ChatRepository {
  final Dio _dio;
  final LocalStorage _storage;

  StompClient? _stompClient;
  StreamController<ChatMessage>? _streamController;
  String? _currentRoomId;

  ChatRepository(this._dio, this._storage);

  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async {
    try {
      final userJson = await _storage.getUser();
      if (userJson == null) return const Left(UnauthorizedFailure());
      final userId = userJson['id'] as int;

      final response = await _dio.get(ApiEndpoints.chatsByUser(userId));
      final data = response.data['data'] as List<dynamic>;
      return Right(
        data.map((e) => ChatRoom.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Failed to load chats',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatMessage>>> getMessages(
      int chatId, int participantId) async {
    try {
      final userJson = await _storage.getUser();
      if (userJson == null) return const Left(UnauthorizedFailure());
      final userId = userJson['id'] as int;

      final response =
          await _dio.get(ApiEndpoints.messages(chatId, userId, participantId));
      final data = response.data['data'] as List<dynamic>;
      return Right(
        data
            .map((e) => ChatMessage.fromRestJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Failed to load messages',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Stream<ChatMessage> subscribeToRoom(String roomId) {
    _currentRoomId = roomId;
    _stompClient?.deactivate();
    _stompClient = null;
    _streamController?.close();
    _streamController = StreamController<ChatMessage>.broadcast();

    final url = '${AppConfig().wsBaseUrl}/ws/chat';
    debugPrint('Connecting WS: $url');

    _stompClient = StompClient(
      config: StompConfig(
        url: url,
        onConnect: (frame) {
          debugPrint('WS connected');
          _stompClient?.subscribe(
            destination: '/topic/room/$roomId',
            callback: (frame) {
              if (frame.body == null) return;
              try {
                final data = jsonDecode(frame.body!) as Map<String, dynamic>;
                _streamController?.add(ChatMessage.fromWebSocketJson(data));
              } catch (e) {
                debugPrint('WS parse error: $e');
              }
            },
          );
        },
        onDisconnect: (_) => debugPrint('WS disconnected'),
        onStompError: (frame) => debugPrint('STOMP error: ${frame.body}'),
      ),
    );

    _stompClient!.activate();
    return _streamController!.stream;
  }

  void sendMessage(int chatId, int userId, String senderName, String content) {
    final now = DateTime.now().toIso8601String();
    _stompClient?.send(
      destination: '/app/chat.sendMessage/$_currentRoomId',
      body: jsonEncode({
        'chatId': chatId,
        'senderId': userId,
        'senderName': senderName,
        'content': content,
        'createdAt': now,
        'modifiedAt': now,
      }),
    );
  }

  void disconnectRoom() {
    _stompClient?.deactivate();
    _stompClient = null;
    _streamController?.close();
    _streamController = null;
    _currentRoomId = null;
  }
}
