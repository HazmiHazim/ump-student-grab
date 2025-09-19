import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:geolocator/geolocator.dart';

class SharedPreferencesUtil {
  static const String _userKey = 'loggedInUser';
  static const String _firstTimeKey = 'isFirstTime';
  // Keys for geolocation
  static const String _latitudeKey = "latitude";
  static const String _longitudeKey = "longitude";

  /// Save User object to SharedPreferences
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode({
      "id": user.id,
      "email": user.email,
      "fullName": user.fullName,
      "gender": user.gender,
      "birthDate": user.birthDate,
      "matricNo": user.matricNo,
      "phoneNo": user.phoneNo,
      "role": user.role,
      "attachmentId": user.attachmentId,
      "isVerified": user.isVerified,
      "token": user.token
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

  // Save location to SharedPreferences
  static Future<void> saveLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, position.latitude);
    await prefs.setDouble(_longitudeKey, position.longitude);
  }

  // Load location from SharedPreferences
  static Future<Position?> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);

    if (latitude == null || longitude == null) return null;

    // Return a Position object with the saved latitude and longitude
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      headingAccuracy: 0.0
    );
  }
}
