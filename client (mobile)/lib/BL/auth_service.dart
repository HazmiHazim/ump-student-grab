import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import '../util/shared_preferences_util.dart';

class AuthService with ChangeNotifier {

  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");

  User? _user;

  // Getter for the authenticated user
  User? get user => _user;

  // Set and notify listeners
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Clear user (on logout or token expiry)
  void clearUser() {
    _user = null;
    SharedPreferencesUtil.clearUser(); // Clear from shared preferences
    notifyListeners();
  }

  // Sign up service
  Future<AuthResponse> signup(String email, String password, String fullName, String matricNo, String phoneNo, String role) async {
    final url = Uri.parse("http://$appDomain:$appPort/api/users/create");
    final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
          "password": password,
          "fullName": fullName,
          "matricNo": matricNo,
          "phoneNo": phoneNo,
          "role": role
        })
    );

    final responseJson = json.decode(response.body);

    if (response.statusCode == 201) {
      return AuthResponse(
          status: response.statusCode,
          userId: null,
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
  }

  // Login service
  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse("http://$appDomain:$appPort/api/users/login");

    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            "email": email,
            "password": password,
          })
      );

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        // Parse user data from the response
        final userData = responseJson["data"];
        final user = User.fromJson(userData);
        // Save the user object in the state
        setUser(user);
        // Save the user data to shared preferences
        await SharedPreferencesUtil.saveUser(user);

        return AuthResponse(
            status: response.statusCode,
            userId: user.id,
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

  // Forgot password service
  Future<AuthResponse> forgotPassword(String email) async {
    final url = Uri.parse("http://$appDomain:$appPort/api/users/forgotPassword?email=$email");
    final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        }
    );

    final responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse(
          status: response.statusCode,
          userId: null,
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
  }
}