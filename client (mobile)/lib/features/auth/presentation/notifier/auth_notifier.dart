import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/auth/model/user.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final repo = ref.read(authRepositoryProvider);
    final cachedUser = await repo.getCachedUser();
    if (cachedUser == null) return null;

    final isValid = await repo.validateSession();
    return isValid ? cachedUser : null;
  }

  Future<Failure?> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).login(email, password);
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
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signup(
      email: email,
      password: password,
      fullName: fullName,
      matricNo: matricNo,
      phoneNo: phoneNo,
    );
    state = const AsyncData(null);
    return result.fold((failure) => failure, (_) => null);
  }

  Future<Failure?> signupDriver({
    required String email,
    required String password,
    required String fullName,
    required String icNo,
    required String phoneNo,
    required String carBrand,
    required String carModel,
    required String plateNo,
    required String carColour,
    required String licenseType,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signupDriver(
      email: email,
      password: password,
      fullName: fullName,
      icNo: icNo,
      phoneNo: phoneNo,
      carBrand: carBrand,
      carModel: carModel,
      plateNo: plateNo,
      carColour: carColour,
      licenseType: licenseType,
    );
    state = const AsyncData(null);
    return result.fold((failure) => failure, (_) => null);
  }

  Future<Failure?> logout() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
    return result.fold((failure) => failure, (_) => null);
  }

  Future<({Failure? failure, String? message})> forgotPassword(String email) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).forgotPassword(email);
    state = const AsyncData(null);
    return result.fold(
      (failure) => (failure: failure, message: null),
      (_) => (failure: null, message: 'Password reset link sent to your email.'),
    );
  }
}
