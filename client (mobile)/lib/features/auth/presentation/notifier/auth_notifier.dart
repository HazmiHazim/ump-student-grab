import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/forgot_password_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/login_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/logout_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/usecase/signup_use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  late LoginUseCase _loginUseCase;
  late SignupUseCase _signupUseCase;
  late LogoutUseCase _logoutUseCase;
  late ForgotPasswordUseCase _forgotPasswordUseCase;

  @override
  Future<User?> build() async {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _signupUseCase = ref.read(signupUseCaseProvider);
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    _forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
    return ref.read(authRepositoryProvider).getCachedUser();
  }

  Future<Failure?> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure;
      },
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
  }

  Future<Failure?> signup({
    required String email,
    required String password,
    required String fullName,
    required String matricNo,
    required String phoneNo,
    required String role,
  }) async {
    state = const AsyncLoading();
    final result = await _signupUseCase(SignupParams(
      email: email,
      password: password,
      fullName: fullName,
      matricNo: matricNo,
      phoneNo: phoneNo,
      role: role,
    ));
    state = const AsyncData(null);
    return result.fold((failure) => failure, (_) => null);
  }

  Future<Failure?> logout() async {
    state = const AsyncLoading();
    final result = await _logoutUseCase(const NoParams());
    state = const AsyncData(null);
    return result.fold((failure) => failure, (_) => null);
  }

  Future<({Failure? failure, String? message})> forgotPassword(String email) async {
    state = const AsyncLoading();
    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    state = const AsyncData(null);
    return result.fold(
      (failure) => (failure: failure, message: null),
      (_) => (failure: null, message: 'Password reset link sent to your email.'),
    );
  }
}
