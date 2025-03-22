import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AccountService with ChangeNotifier {
  final String appDomain = dotenv.get("APP_DOMAIN");
  final String appPort = dotenv.get("APP_PORT");

  Future<Uint8List?> getUserImage(int imageId) async {
    final url = Uri.parse("http://$appDomain:$appPort/api/attachments/getFileById/$imageId");
    final response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Returning the file data as Uint8List
      return response.bodyBytes;
    } else {
      print("File missing or error: ${response.statusCode}");
      return null;
    }
  }
}