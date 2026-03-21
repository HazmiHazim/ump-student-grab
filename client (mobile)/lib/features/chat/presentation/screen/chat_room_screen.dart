import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';

import 'package:ump_student_grab_mobile/features/chat/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/chat_room_args.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final ChatRoomArgs args;
  const ChatRoomScreen({super.key, required this.args});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;
    await ref
        .read(chatRoomNotifierProvider(widget.args.chatId).notifier)
        .initialize(widget.args.recipientId);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatRoomNotifierProvider(widget.args.chatId));

    // Scroll to bottom when new messages arrive
    ref.listen(chatRoomNotifierProvider(widget.args.chatId), (_, __) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(title: Text(widget.args.recipientName)),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ref.read(localStorageProvider).getUser(),
        builder: (context, userSnapshot) {
          final currentUserId = userSnapshot.data?['id'] as int?;
          final currentUserName =
              userSnapshot.data?['fullName'] as String? ?? '';

          return Column(
            children: [
              Expanded(
                child: chatState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: chatState.messages.length,
                        itemBuilder: (ctx, index) {
                          final msg = chatState.messages[index];
                          final isMe = msg.userId == currentUserId;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.green : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                msg.content,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 246, 246, 246),
                          border: Border.all(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextField(
                          controller: _inputController,
                          autocorrect: false,
                          enableSuggestions: false,
                          cursorColor: AppColor.primary,
                          maxLines: null,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 105, 105, 105)),
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 157, 157, 157)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColor.primary),
                      onPressed: () {
                        final text = _inputController.text.trim();
                        if (text.isEmpty || currentUserId == null) return;
                        ref
                            .read(chatRoomNotifierProvider(widget.args.chatId)
                                .notifier)
                            .sendMessage(currentUserId, currentUserName, text);
                        _inputController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
