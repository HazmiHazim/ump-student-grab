import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/BL/chat_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/Model/chat_message.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import '../../Model/user.dart';
import '../../util/shared_preferences_util.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = "/chat-room-screen";

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late int chatId;
  late int recipientId;
  final TextEditingController chatInputController = TextEditingController();
  final List<ChatMessage> messages = [];
  late ChatWebsocketService chatWebsocketService;
  late Future<User?> userFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    userFuture = SharedPreferencesUtil.loadUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      chatId = args['chatId'];
      recipientId = args['recipientId'];

      chatWebsocketService = Provider.of<ChatWebsocketService>(context, listen: false);
      chatWebsocketService.startConnection(chatId.toString());

      chatWebsocketService.addListener(() {
        final newMessage = chatWebsocketService.latestMessage;

        // Check if the message already exists in the list (by ID)
        final exists = messages.any((msg) => msg.createdAt == newMessage.createdAt);

        if (!exists) {
          setState(() {
            messages.add(newMessage);
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(scrollController.position.minScrollExtent);
            }
          });
        }
      });

      fetchInitialMessages();
    });
  }

  Future<void> fetchInitialMessages() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final fetchedMessages = await chatService.getAllMessages(chatId, recipientId);
    if (fetchedMessages != null) {
      setState(() {
        messages.addAll(fetchedMessages.map((msg) => ChatMessage.fromMessageResponse(msg)));
      });

      // Scroll to bottom after loading messages
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }
  }

  @override
  void dispose() {
    chatInputController.dispose();
    scrollController.dispose();
    chatWebsocketService.stopConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Chat Room")),
      body: FutureBuilder<User?>(
        future: userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError || !userSnapshot.hasData) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          final currentUserId = userSnapshot.data!.id;
          final currentUserName = userSnapshot.data!.fullName;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[messages.length - 1 - index]; // reverse order
                    final isUserMessage = message.userId == currentUserId;
                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.green : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(message.content, style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatInputController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColor.primary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColor.primary),
                      onPressed: () {
                        if (chatInputController.text.isNotEmpty) {
                          // Send message via WebSocket
                          chatWebsocketService.sendMessage(
                            chatId,
                            currentUserId,
                            currentUserName,
                            chatInputController.text,
                          );
                          // Clear the input box
                          chatInputController.clear();
                        }
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

