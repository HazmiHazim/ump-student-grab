import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/usecase/get_chat_rooms_use_case.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';

class ChatListNotifier extends AsyncNotifier<List<ChatRoom>> {
  late GetChatRoomsUseCase _useCase;

  @override
  Future<List<ChatRoom>> build() async {
    _useCase = ref.read(getChatRoomsUseCaseProvider);
    return _loadRooms();
  }

  Future<List<ChatRoom>> _loadRooms() async {
    final result = await _useCase(const NoParams());
    return result.fold((f) => throw f, (rooms) => rooms);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadRooms);
  }
}
