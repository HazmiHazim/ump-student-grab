import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';

class SharedPreferencesUtil {
  static const String _userKey = 'loggedInUser';
  static const String _firstTimeKey = 'isFirstTime';

  /// Save User object to SharedPreferences
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode({
      "id": user.id,
      "email": user.email,
      "fullName": user.fullName,
      "matricNo": user.matricNo,
      "phoneNo": user.phoneNo,
      "role": user.role,
      "isVerified": user.isVerified,
    });
    await prefs.setString(_userKey, userJson);
  }

  /// Load User object from SharedPreferences
  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson == null) return null;

    final Map<String, dynamic> userMap = json.decode(userJson);
    return User.fromJson(userMap);
  }

  /// Clear User object from SharedPreferences
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Check if this is the first time the app is opened
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeKey);

    // If null, it's the first time. Update the flag.
    if (isFirstTime == null || isFirstTime) {
      await prefs.setBool(_firstTimeKey, false);
      return true;
    }
    return false;
  }
}
