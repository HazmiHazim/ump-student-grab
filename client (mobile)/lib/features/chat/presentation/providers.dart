import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/chat/data/datasource/chat_websocket_data_source.dart';
import 'package:ump_student_grab_mobile/features/chat/data/repository/chat_repository_impl.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/repository/chat_repository.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/usecase/get_chat_rooms_use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/usecase/get_messages_use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/notifier/chat_list_notifier.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/notifier/chat_room_notifier.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(
    ref.read(dioProvider),
    ref.read(localStorageProvider),
  );
});

final chatWebsocketDataSourceProvider = Provider<ChatWebsocketDataSource>((ref) {
  return ChatWebsocketDataSourceImpl();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.read(chatRemoteDataSourceProvider),
    ref.read(chatWebsocketDataSourceProvider),
  );
});

final getChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>((ref) {
  return GetChatRoomsUseCase(ref.read(chatRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  return GetMessagesUseCase(ref.read(chatRepositoryProvider));
});

final chatListNotifierProvider =
    AsyncNotifierProvider<ChatListNotifier, List<ChatRoom>>(
  ChatListNotifier.new,
);

final chatRoomNotifierProvider =
    NotifierProvider.family<ChatRoomNotifier, ChatRoomState, int>(
  ChatRoomNotifier.new,
);
