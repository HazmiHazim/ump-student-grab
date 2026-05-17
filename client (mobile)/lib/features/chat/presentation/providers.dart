import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/notifier/chat_list_notifier.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/notifier/chat_room_notifier.dart';
import 'package:ump_student_grab_mobile/features/chat/repository/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(dioProvider), ref.read(localStorageProvider));
});

final chatListNotifierProvider =
    AsyncNotifierProvider<ChatListNotifier, List<ChatRoom>>(
  ChatListNotifier.new,
);

final chatRoomNotifierProvider =
    NotifierProvider.family<ChatRoomNotifier, ChatRoomState, int>(
  ChatRoomNotifier.new,
);
