import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Model/location_response.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';

class LocationService with ChangeNotifier {
  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");

  Future<LocationResponse> getOrCreateUserLocation(double latitude, double longitude) async {
    // Load user from SharedPreferences using the utility method
    User? user = await SharedPreferencesUtil.loadUser();

    if (user == null) {
      throw Exception("User is not authenticated or user data is missing.");
    }

    final userId = user.id;

    final url = Uri.parse("http://$appDomain:$appPort/api/locations/createLocation/$userId");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "userId": userId,
        "latitude": latitude,
        "longitude": longitude
      })
    );

    final responseJson = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LocationResponse(
          status: response.statusCode,
          userId: responseJson["userId"],
          latitude: responseJson["latitude"],
          longitude: responseJson["longitude"],
          message: responseJson["message"]
      );
    } else {
      return LocationResponse(
          status: response.statusCode,
          userId: null,
          latitude: 0,
          longitude: 0,
          message: responseJson["message"]
      );
    }
  }

}