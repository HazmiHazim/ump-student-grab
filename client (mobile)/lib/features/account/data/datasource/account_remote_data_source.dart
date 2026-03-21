import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/features/account/data/model/profile_model.dart';

abstract class AccountRemoteDataSource {
  Future<ProfileModel> getProfile(int userId);
  Future<ProfileModel> updateProfile(int userId, Map<String, dynamic> body);
  Future<Uint8List?> getAvatar(int attachmentId);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Dio _dio;
  AccountRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileModel> getProfile(int userId) async {
    final response = await _dio.get(ApiEndpoints.userById(userId));
    return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfile(int userId, Map<String, dynamic> body) async {
    final response = await _dio.put(ApiEndpoints.userById(userId), data: body);
    return ProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<Uint8List?> getAvatar(int attachmentId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.attachment(attachmentId),
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data as Uint8List;
    } catch (_) {
      return null;
    }
  }
}
