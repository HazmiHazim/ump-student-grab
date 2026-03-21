import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/config/app_config.dart';
import 'package:ump_student_grab_mobile/core/network/auth_interceptor.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return SharedPrefsLocalStorage();
});

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(localStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig().baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(AuthInterceptor(storage));
  return dio;
});
