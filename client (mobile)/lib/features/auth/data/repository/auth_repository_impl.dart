import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:ump_student_grab_mobile/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final model = await _remote.login(email, password);
      await _local.saveUser(model);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      final message = _extractMessage(e) ?? 'Login failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String fullName,
    required String matricNo,
    required String phoneNo,
    required String role,
  }) async {
    try {
      await _remote.signup(
        email: email,
        password: password,
        fullName: fullName,
        matricNo: matricNo,
        phoneNo: phoneNo,
        role: role,
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return const Left(NetworkFailure());
      }
      final message = _extractMessage(e) ?? 'Signup failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      await _local.clearUser();
      return const Right(null);
    } on DioException catch (e) {
      // Still clear local data even if API call fails
      await _local.clearUser();
      final message = _extractMessage(e) ?? 'Logout failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      await _local.clearUser();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      final message = _extractMessage(e) ?? 'Request failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<User?> getCachedUser() => _local.getUser();

  String? _extractMessage(DioException e) {
    try {
      return e.response?.data['message'] as String?;
    } catch (_) {
      return null;
    }
  }
}
