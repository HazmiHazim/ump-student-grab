import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/BL/chat_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/Model/chat_message.dart';
import 'package:ump_student_grab_mobile/Model/message_response.dart';
import 'package:ump_student_grab_mobile/Model/message_websocket.dart';
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
  //final List<MessageWebsocket> messages = [];
  final List<ChatMessage> messages = [];
  late ChatWebsocketService chatWebsocketService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    chatId = arguments['chatId'];
    recipientId = arguments['recipientId'];

    // Initialize ChatWebsocketService
    chatWebsocketService = Provider.of<ChatWebsocketService>(context, listen: false);
    chatWebsocketService.startConnection(chatId.toString());

    // Subscribe to WebSocket messages
    chatWebsocketService.addListener(() {
      setState(() {
        //messages.clear();
        //messages.addAll(chatWebsocketService.messages);
        messages.add(chatWebsocketService.latestMessage);
      });
    });

    // Fetch initial messages
    fetchInitialMessages();
  }

  Future<void> fetchInitialMessages() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final fetchedMessages = await chatService.getAllMessages(chatId, recipientId);
    if (fetchedMessages != null) {
      setState(() {
        messages.addAll(fetchedMessages.map((msg) => ChatMessage.fromMessageResponse(msg)));
      });
    }
  }

  @override
  void dispose() {
    chatInputController.dispose();
    chatWebsocketService.stopConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Chat Room"),
      ),
      body: FutureBuilder<User?>(
        future: SharedPreferencesUtil.loadUser(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError || !userSnapshot.hasData) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          int currentUserId = userSnapshot.data!.id;
          String currentUserName = userSnapshot.data!.fullName;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: messages.map((message) {
                      bool isUserMessage = message.userId == currentUserId;

                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.green
                                : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                            borderSide: BorderSide(color: Color.fromRGBO(0, 159, 160, 100)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Color.fromRGBO(0, 159, 160, 100)),
                      onPressed: () {
                        if (chatInputController.text.isNotEmpty) {
                          // Send message via WebSocket
                          chatWebsocketService.sendMessage(
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
