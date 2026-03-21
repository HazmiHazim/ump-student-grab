import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> saveUser(Map<String, dynamic> userJson);
  Future<Map<String, dynamic>?> getUser();
  Future<String?> getToken();
  Future<void> clearUser();
  Future<bool> isFirstTime();
}

class SharedPrefsLocalStorage implements LocalStorage {
  static const _userKey = 'loggedInUser';
  static const _firstTimeKey = 'isFirstTime';

  @override
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(userJson));
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  @override
  Future<String?> getToken() async {
    final user = await getUser();
    return user?['token'] as String?;
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_firstTimeKey);
    if (value == null || value) {
      await prefs.setBool(_firstTimeKey, false);
      return true;
    }
    return false;
  }
}
