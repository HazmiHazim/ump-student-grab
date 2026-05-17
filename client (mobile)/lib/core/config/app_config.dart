import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._();
  AppConfig._();
  factory AppConfig() => _instance;

  late final String baseUrl;
  late final String wsBaseUrl;

  void init() {
    final domain = dotenv.get('APP_DOMAIN');
    final port = dotenv.get('APP_PORT');
    baseUrl = 'http://$domain:$port';
    wsBaseUrl = 'ws://$domain:$port';
  }
}
