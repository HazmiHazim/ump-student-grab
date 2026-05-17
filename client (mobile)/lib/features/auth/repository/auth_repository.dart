import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/auth/model/user.dart';

class AuthRepository {
  final Dio _dio;
  final LocalStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final user = User.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.saveUser(user.toJson());
      return Right(user);
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

  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String fullName,
    required String matricNo,
    required String phoneNo,
    required String role,
  }) async {
    try {
      await _dio.post(
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

  Future<Either<Failure, void>> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
      await _storage.clearUser();
      return const Right(null);
    } on DioException catch (e) {
      await _storage.clearUser();
      final message = _extractMessage(e) ?? 'Logout failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      await _storage.clearUser();
      return const Right(null);
    }
  }

  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return const Right(null);
    } on DioException catch (e) {
      final message = _extractMessage(e) ?? 'Request failed';
      return Left(ServerFailure(message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<User?> getCachedUser() async {
    final json = await _storage.getUser();
    if (json == null) return null;
    return User.fromJson(json);
  }

  Future<bool> validateSession() async {
    try {
      final user = await getCachedUser();
      if (user == null) return false;
      await _dio.get(ApiEndpoints.userById(user.id));
      return true;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return true;
      }
      await _storage.clearUser();
      return false;
    } catch (_) {
      return true;
    }
  }

  Future<bool> isFirstTime() => _storage.isFirstTime();

  String? _extractMessage(DioException e) {
    try {
      return e.response?.data['message'] as String?;
    } catch (_) {
      return null;
    }
  }
}
