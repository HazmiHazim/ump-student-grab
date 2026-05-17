import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_message.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';

class ChatRoomState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatRoomState({this.messages = const [], this.isLoading = false});

  ChatRoomState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatRoomState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatRoomNotifier extends FamilyNotifier<ChatRoomState, int> {
  late int _chatId;
  StreamSubscription<ChatMessage>? _subscription;

  @override
  ChatRoomState build(int chatId) {
    _chatId = chatId;
    ref.onDispose(() {
      _subscription?.cancel();
      ref.read(chatRepositoryProvider).disconnectRoom();
    });
    return const ChatRoomState(isLoading: true);
  }

  Future<void> initialize(int recipientId) async {
    final repo = ref.read(chatRepositoryProvider);

    final result = await repo.getMessages(_chatId, recipientId);
    final history = result.fold((_) => <ChatMessage>[], (messages) => messages);
    state = state.copyWith(messages: history, isLoading: false);

    _subscription = repo.subscribeToRoom(_chatId.toString()).listen((msg) {
      final alreadyExists = state.messages.any((m) =>
          m.createdAt == msg.createdAt &&
          m.userId == msg.userId &&
          m.content == msg.content);
      if (!alreadyExists) {
        state = state.copyWith(messages: [...state.messages, msg]);
      }
    });
  }

  void sendMessage(int userId, String senderName, String content) {
    ref.read(chatRepositoryProvider).sendMessage(_chatId, userId, senderName, content);
  }
}
