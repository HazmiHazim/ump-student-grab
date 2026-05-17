import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/account/model/profile.dart';

class AccountRepository {
  final Dio _dio;
  final LocalStorage _storage;

  AccountRepository(this._dio, this._storage);

  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final userJson = await _storage.getUser();
      if (userJson == null) return const Left(UnauthorizedFailure());
      final userId = userJson['id'] as int;

      final response = await _dio.get(ApiEndpoints.userById(userId));
      Profile profile = Profile.fromJson(response.data['data'] as Map<String, dynamic>);

      if (profile.attachmentId != null) {
        final avatarBytes = await _getAvatar(profile.attachmentId!);
        if (avatarBytes != null) {
          profile = profile.copyWith(avatarBytes: avatarBytes);
        }
      }

      return Right(profile);
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String? ?? 'Failed to load profile';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, Profile>> updateProfile({
    String? fullName,
    String? matricNo,
    String? birthDate,
    String? gender,
    String? phoneNo,
    String? email,
  }) async {
    try {
      final userJson = await _storage.getUser();
      if (userJson == null) return const Left(UnauthorizedFailure());
      final userId = userJson['id'] as int;
      final token = userJson['token'] as String?;

      final body = <String, dynamic>{
        if (fullName != null) 'fullName': fullName,
        if (matricNo != null) 'matricNo': matricNo,
        if (birthDate != null) 'birthDate': birthDate,
        if (gender != null) 'gender': gender,
        if (phoneNo != null) 'phoneNo': phoneNo,
        if (email != null) 'email': email,
      };

      final response = await _dio.put(ApiEndpoints.userById(userId), data: body);
      final profile = Profile.fromJson(response.data['data'] as Map<String, dynamic>);

      final updatedJson = Map<String, dynamic>.from(userJson)
        ..addAll({
          'fullName': profile.fullName,
          'matricNo': profile.matricNo,
          'birthDate': profile.birthDate,
          'gender': profile.gender,
          'phoneNo': profile.phoneNo,
          'email': profile.email,
          'token': token ?? '',
        });
      await _storage.saveUser(updatedJson);

      return Right(profile);
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String? ?? 'Update failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Uint8List?> _getAvatar(int attachmentId) async {
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
