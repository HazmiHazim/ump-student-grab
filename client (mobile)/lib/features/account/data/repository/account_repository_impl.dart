import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/account/data/datasource/account_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';
import 'package:ump_student_grab_mobile/features/account/domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote;
  final LocalStorage _storage;

  AccountRepositoryImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final userJson = await _storage.getUser();
      if (userJson == null) return const Left(UnauthorizedFailure());
      final userId = userJson['id'] as int;

      final model = await _remote.getProfile(userId);
      Profile profile = model.toEntity();

      if (model.attachmentId != null) {
        final avatarBytes = await _remote.getAvatar(model.attachmentId!);
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

  @override
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

      final model = await _remote.updateProfile(userId, body);

      // Update cached user with new values
      final updatedJson = Map<String, dynamic>.from(userJson)
        ..addAll({
          'fullName': model.fullName,
          'matricNo': model.matricNo,
          'birthDate': model.birthDate,
          'gender': model.gender,
          'phoneNo': model.phoneNo,
          'email': model.email,
          'token': token ?? '',
        });
      await _storage.saveUser(updatedJson);

      return Right(model.toEntity());
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String? ?? 'Update failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
