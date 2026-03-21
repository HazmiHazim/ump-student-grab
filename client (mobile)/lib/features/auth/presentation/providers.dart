import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:ump_student_grab_mobile/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/auth/data/repository/auth_repository_impl.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/forgot_password_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/login_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/logout_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/signup_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/notifier/auth_notifier.dart';

// Data sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.read(localStorageProvider));
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(authLocalDataSourceProvider),
  );
});

// Use cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.read(authRepositoryProvider));
});

// Notifier
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
