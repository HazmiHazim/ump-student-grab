import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Model/place_result.dart';
import 'package:ump_student_grab_mobile/Model/place_suggestion.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';

class PlacesService {
  final String _appDomain = dotenv.get("APP_DOMAIN");
  final String _appPort = dotenv.get("APP_PORT");
  final String _apiKey = dotenv.get("API_KEY");

  String get _baseUrl => "http://$_appDomain:$_appPort/api/places";

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "X-Api-Key": _apiKey,
      };

  Future<List<PlaceSuggestion>> autocomplete(String query, {String region = "MY"}) async {
    final url = Uri.parse("$_baseUrl/autocomplete?query=${Uri.encodeComponent(query)}&region=$region");
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => PlaceSuggestion.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<PlaceResult>> searchByText(String query, {String region = "MY"}) async {
    final url = Uri.parse("$_baseUrl/search?query=${Uri.encodeComponent(query)}&region=$region");
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => PlaceResult.fromJson(e)).toList();
    }
    return [];
  }

  Future<String?> getDirections(String origin, String destination) async {
    final url = Uri.parse(
        "$_baseUrl/directions?origin=${Uri.encodeComponent(origin)}&destination=${Uri.encodeComponent(destination)}");
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['encodedPolyline'] as String?;
    }
    return null;
  }
}
