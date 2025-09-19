import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/BL/chat_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/Model/chat_response.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:ump_student_grab_mobile/widget/custom_chat_list.dart';

class MainChatScreen extends StatefulWidget {
  static const routeName = "/main-chat-screen";

  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  late final ChatWebsocketService _chatService;

  // @override
  // void initState() {
  //   super.initState();
  //   // Get the service only once and store it in a member variable
  //   _chatService = Provider.of<ChatWebsocketService>(context, listen: false);
  //   _chatService.startConnection();
  // }

  @override
  void dispose() {
    // Use the stored service reference to stop the connection
    _chatService.stopConnection();
    super.dispose();
  }

  Future<int?> _getCurrentUserId() async {
    final user = await SharedPreferencesUtil.loadUser();
    return user?.id; // Return the current user's ID
  }

  void _navigateToChatRoom(BuildContext context, ChatResponse chat) async {
    final currentUserId = await _getCurrentUserId();

    // Update recipientId if it matches the current user ID
    int recipientId = chat.recipientId;
    String recipientName = chat.recipientName;

    if (recipientId == currentUserId) {
      recipientId = chat.senderId;
      recipientName = chat.senderName;
    }

    // Navigate to chat room with updated recipientId
    Navigator.pushNamed(context, "/chat-room-screen", arguments: {
      'chatId': chat.chatId,
      'recipientId': recipientId,
      'recipientName': recipientName,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dummy chat data for testing
    // final dummyChats = [
    //   {"recipientName": "Alice", "lastMessage": "Hello! How are you?"},
    //   {"recipientName": "Bob", "lastMessage": "See you tomorrow."},
    //   {"recipientName": "Charlie", "lastMessage": "Let's catch up soon!"},
    // ];
    return FutureBuilder<int?>(
      future: _getCurrentUserId(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError || userSnapshot.data == null) {
          return Center(child: Text('Failed to load user'));
        }

        final currentUserId = userSnapshot.data!;

        return Consumer<ChatService>(
          builder: (context, chatService, child) {
            return FutureBuilder<List<ChatResponse>>(
              future: chatService.getAllChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No chats available.'));
                }

                final chats = snapshot.data!;

                return SingleChildScrollView(
                  reverse: false,
                  child: Column(
                    children: chats.map((chat) {
                      return InkWell(
                        onTap: () => _navigateToChatRoom(context, chat),
                        child: CustomChatList(
                          recipientName: chat.senderId == currentUserId ? chat
                              .recipientName : chat.senderName,
                          lastMessage: chat.lastMessage,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}
