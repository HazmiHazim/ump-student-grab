import 'package:dio/dio.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<String> signup({
    required String email,
    required String password,
    required String fullName,
    required String matricNo,
    required String phoneNo,
    required String role,
  });
  Future<void> logout();
  Future<String> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<String> signup({
    required String email,
    required String password,
    required String fullName,
    required String matricNo,
    required String phoneNo,
    required String role,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.signup,
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'matricNo': matricNo,
        'phoneNo': phoneNo,
        'role': role,
      },
    );
    return response.data['message'] as String;
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await _dio.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return response.data['message'] as String;
  }
}
