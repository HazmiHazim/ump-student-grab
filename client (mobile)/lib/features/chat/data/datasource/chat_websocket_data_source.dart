import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/features/chat/data/model/chat_message_model.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_message.dart';

abstract class ChatWebsocketDataSource {
  Stream<ChatMessage> subscribeToRoom(String roomId);
  void sendMessage(int chatId, int userId, String senderName, String content);
  void disconnect();
}

class ChatWebsocketDataSourceImpl implements ChatWebsocketDataSource {
  StompClient? _stompClient;
  StreamController<ChatMessage>? _streamController;
  String? _currentRoomId;

  @override
  Stream<ChatMessage> subscribeToRoom(String roomId) {
    _currentRoomId = roomId;
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
                final model = ChatMessageModel.fromWebSocketJson(data);
                _streamController?.add(model.toEntity());
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

  @override
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

  @override
  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
    _streamController?.close();
    _streamController = null;
    _currentRoomId = null;
  }
}
