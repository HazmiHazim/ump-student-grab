import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';

import '../Model/user.dart';

class AccountService with ChangeNotifier {
  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");
  final String apiKey = dotenv.get("API_KEY");

  Future<Uint8List?> getUserImage(int imageId) async {
    final url = Uri.parse("http://$appDomain:$appPort/api/attachments/getFileById/$imageId");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-Api-Key": apiKey
      }
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Returning the file data as Uint8List
      return response.bodyBytes;
    } else {
      print("File missing or error: ${response.statusCode}");
      return null;
    }
  }

  Future<AuthResponse> updatePersonalInfo(String fullName, String matricNo, String phoneNo, String email) async {
    // Load user from SharedPreferences using the utility method
    User? user = await SharedPreferencesUtil.loadUser();

    if (user == null) {
      throw Exception("User is not authenticated or user data is missing.");
    }

    final userId = user.id;

    try {
      final url = Uri.parse("http://$appDomain:$appPort/api/users/$userId");

      final response = await http.put(
          url,
          headers: {
            "Content-Type": "application/json",
            "X-Api-Key": apiKey
          },
          body: json.encode({
            "fullName": fullName,
            "matricNo": matricNo,
            "phoneNo": phoneNo,
            "email": email,
          })
      );

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse(
            status: response.statusCode,
            userId: userId,
            isSuccess: true,
            message: responseJson["message"]
        );
      } else {
        return AuthResponse(
            status: response.statusCode,
            userId: null,
            isSuccess: false,
            message: responseJson["message"]
        );
      }
    } catch (exception) {
      return AuthResponse(
        status: 0,
        userId: null,
        isSuccess: false,
        message: "An unexpected error occurred: ${exception.toString()}",
      );
    }
  }
}