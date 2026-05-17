import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';

class ChatListNotifier extends AsyncNotifier<List<ChatRoom>> {
  @override
  Future<List<ChatRoom>> build() async => _loadRooms();

  Future<List<ChatRoom>> _loadRooms() async {
    final result = await ref.read(chatRepositoryProvider).getChatRooms();
    return result.fold((f) => throw f, (rooms) => rooms);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadRooms);
  }
}
