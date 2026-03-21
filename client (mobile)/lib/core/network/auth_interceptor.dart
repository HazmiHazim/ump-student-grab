import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['X-Api-Key'] = AppConfig().apiKey;
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      debugPrint('AuthInterceptor: 401 Unauthorized — ${err.requestOptions.path}');
      await _storage.clearUser();
    } else {
      debugPrint('AuthInterceptor: HTTP ${err.response?.statusCode} — ${err.message}');
    }
    handler.next(err);
  }
}
