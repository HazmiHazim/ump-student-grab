import 'package:dio/dio.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['X-Api-Key'] = AppConfig().apiKey;
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
