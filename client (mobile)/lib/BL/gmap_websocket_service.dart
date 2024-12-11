import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ump_student_grab_mobile/Model/location.dart';
import 'package:ump_student_grab_mobile/Model/message_response.dart';

class GmapWebsocketService extends ChangeNotifier {

  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");
  late StompClient stompClient;
  late StompFrame stompFrame;
  List<MessageResponse> _messages = [];

  // Start WebSocket connection and listen for messages
  void startConnection() {
    final url = 'ws://$appDomain:$appPort/location';  // WebSocket URL for connection
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
      destination: '/topic/mylocation',
      callback: onMessageReceived,
    );
  }

  // Called when a message is received from the server
  void onMessageReceived(StompFrame frame) {
    print('Received message: ${frame.body}');
    try {
      final List<dynamic> data = jsonDecode(frame.body!);
      List<MessageResponse> messagesResponse = data.map((item) => MessageResponse.fromJson(item)).toList();
      _messages.addAll(messagesResponse);
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

  // Send location to the backend
  void sendLocation(Location location) {
    stompClient.send(
      destination: '/app/location', // Server-side endpoint to handle location
      body: json.encode({
        "userId": "userId",
        "latitude": "3232.3232",
        "longitude": "323232.3232"
      })
    );
  }
}