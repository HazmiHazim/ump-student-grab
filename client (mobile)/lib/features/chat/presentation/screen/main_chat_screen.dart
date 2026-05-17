import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/chat/model/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/chat_room_args.dart';
import 'package:ump_student_grab_mobile/widget/custom_chat_list.dart';

class MainChatScreen extends ConsumerStatefulWidget {
  const MainChatScreen({super.key});

  @override
  ConsumerState<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends ConsumerState<MainChatScreen> {
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userJson = await ref.read(localStorageProvider).getUser();
    if (mounted) {
      setState(() {
        _currentUserId = userJson?['id'] as int?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatListAsync = ref.watch(chatListNotifierProvider);

    return chatListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (chats) => _buildList(context, chats),
    );
  }

  Widget _buildList(BuildContext context, List<ChatRoom> chats) {
    if (chats.isEmpty) {
      return const Center(child: Text('No chats available.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: chats.map((chat) {
          final displayName = chat.senderId == _currentUserId
              ? chat.recipientName
              : chat.senderName;

          int recipientId = chat.recipientId;
          String recipientName = chat.recipientName;
          if (recipientId == _currentUserId) {
            recipientId = chat.senderId;
            recipientName = chat.senderName;
          }

          return InkWell(
            onTap: () => context.push(
              '/chat/room',
              extra: ChatRoomArgs(
                chatId: chat.chatId,
                recipientId: recipientId,
                recipientName: recipientName,
              ),
            ),
            child: CustomChatList(
              recipientName: displayName,
              lastMessage: chat.lastMessage,
            ),
          );
        }).toList(),
      ),
    );
  }
}
