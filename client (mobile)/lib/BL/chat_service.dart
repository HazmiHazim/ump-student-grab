import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Model/chat_response.dart';
import 'package:http/http.dart' as http;
import 'package:ump_student_grab_mobile/Model/message_response.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';

import '../Model/user.dart';

class ChatService with ChangeNotifier {

  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");
  final String apiKey = dotenv.get("API_KEY");

  // Get all chats service
  Future<List<ChatResponse>> getAllChats() async {
    // Load user from SharedPreferences using the utility method
    User? user = await SharedPreferencesUtil.loadUser();

    if (user == null) {
      throw Exception("User is not authenticated or user data is missing.");
    }

    final userId = user.id;
    //print("Current user id: $userId");

    final url = Uri.parse("http://$appDomain:$appPort/api/chats/details/$userId");
    final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Api-Key": apiKey
        }
    );

    List<ChatResponse> chats = [];
    final responseJson = json.decode(response.body);

    //print(responseJson);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Map the "data" array to a list of ChatResponse objects
      for (var chat in responseJson["data"]) {
        int chatId = chat["chatId"];
        int senderId = chat["senderId"];
        String senderName = chat["senderFullName"] ?? "";
        int recipientId = chat["recipientId"];
        String recipientName = chat["recipientFullName"] ?? "";
        String lastMessage = chat["lastMessage"] ?? "";
        chats.add(ChatResponse(
          status: response.statusCode,
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
          recipientId: recipientId,
          recipientName: recipientName,
          lastMessage: lastMessage,
        ));
      }
    }

    return chats;
  }

  Future<List<MessageResponse>?> getAllMessages(int chatId, int participantId) async {
    // Load user from SharedPreferences using the utility method
    User? user = await SharedPreferencesUtil.loadUser();

    //print("Chat ID: $chatId");
    //print("participant ID: $participantId");

    if (user == null) {
      throw Exception("User is not authenticated or user data is missing.");
    }

    final userId = user.id;
    //print("User ID: $userId");
    final url = Uri.parse("http://$appDomain:$appPort/api/chats/message/$chatId/$userId/$participantId");
    final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Api-Key": apiKey
        }
    );

    List<MessageResponse> messages = [];
    final responseJson = json.decode(response.body);
    //print("JSON: $responseJson");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Map the "data" array to a list of ChatResponse objects
      for (var message in responseJson["data"]) {
        String content = message["content"] ?? "";
        String attachment = message["attachment"] ?? "";
        int userId = message["userId"];
        DateTime createdAt = DateTime.parse(message["createdAt"]);
        DateTime modifiedAt = DateTime.parse(message["modifiedAt"]);
        messages.add(MessageResponse(
          status: response.statusCode,
          content: content,
          attachment: attachment,
          userId: userId,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
          isSuccess: true,
          responseMessage: responseJson["message"],
        ));
      }
    } else {
      return null;
    }

    return messages;
  }
}