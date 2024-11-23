import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ump_student_grab_mobile/Model/message_response.dart';

class ChatWebsocketService with ChangeNotifier {

  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");
  late StompClient stompClient;
  late StompFrame stompFrame;
  List<MessageResponse> _messages = [];

  // Getter to access the chats list
  List<MessageResponse> get messages => _messages;

  // Start WebSocket connection and listen for messages
  void startConnection() {
    final url = 'ws://$appDomain:$appPort/chat';  // WebSocket URL for connection
    print("Connecting to WebSocket: $url");

    // Create StompClient instance and connect
    stompClient = StompClient(
      config: StompConfig(
        url: url,
        onConnect: onConnect, // Callback when the connection is established
        onDisconnect: onDisconnect, // Callback when the connection is closed
        onStompError: onStompError, // Callback when there's an error with STOMP
      ),
    );

    // Connect to the server
    stompClient.activate();
  }

  // Called once the WebSocket connection is established
  void onConnect(StompFrame frame) {
    print('Connected to WebSocket');
    // Subscribe to the /topic/allChats destination
    stompClient.subscribe(
      destination: '/topic/allChats',
      callback: onMessageReceived,
    );
  }

  // Called when a message is received from the server
  void onMessageReceived(StompFrame frame) {
    print("HEHEHEHEHHE");
    print('Received message: ${frame.body}');
    try {
      final List<dynamic> data = jsonDecode(frame.body!);
      List<MessageResponse> messagesResponse = data.map((item) => MessageResponse.fromJson(item)).toList();
      _messages.addAll(messagesResponse);
      print("Updated Messages List: $_messages"); // Check if messages are added
      notifyListeners(); // Notify the listeners to update UI
    } catch (e) {
      print("Error parsing message: $e");
    }
  }


  // Callback to handle connection errors
  void onStompError(StompFrame frame) {
    print('STOMP Error: ${frame.body}');
  }

  // Called once the WebSocket connection is closed
  void onDisconnect(StompFrame frame) {
    print('WebSocket disconnected');
  }

  // Stop the WebSocket connection
  void stopConnection() {
    stompClient.deactivate();  // Disconnect the STOMP client
  }

  // Send a message via WebSocket
  void sendMessage(String messageContent, String attachment, int userId, int chatId) {
    final messageCreateDTO = {
      "content": messageContent,
      "attachment": attachment,
      "userId": userId,
      "chatId": chatId
    };

    final jsonBody = jsonEncode(messageCreateDTO);

    stompClient.send(
      destination: "/app/chat",  // The Spring endpoint for sending messages
      body: jsonBody,
    );
  }
}