import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/chat/domain/entity/chat_room.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/chat_room_args.dart';
import 'package:ump_student_grab_mobile/widget/custom_chat_list.dart';

class MainChatScreen extends ConsumerWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListNotifierProvider);

    return chatListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (chats) => _buildList(context, ref, chats),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<ChatRoom> chats) {
    if (chats.isEmpty) {
      return const Center(child: Text('No chats available.'));
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: ref.read(localStorageProvider).getUser(),
      builder: (context, snapshot) {
        final currentUserId = snapshot.data?['id'] as int?;

        return SingleChildScrollView(
          child: Column(
            children: chats.map((chat) {
              final displayName = chat.senderId == currentUserId
                  ? chat.recipientName
                  : chat.senderName;

              // Figure out the correct recipient for the chat room
              int recipientId = chat.recipientId;
              String recipientName = chat.recipientName;
              if (recipientId == currentUserId) {
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
      },
    );
  }
}
