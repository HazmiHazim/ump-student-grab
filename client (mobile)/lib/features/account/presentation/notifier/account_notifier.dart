import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/account/model/profile.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/providers.dart';

class UpdateProfileParams {
  final String? fullName;
  final String? matricNo;
  final String? birthDate;
  final String? gender;
  final String? phoneNo;
  final String? email;

  const UpdateProfileParams({
    this.fullName,
    this.matricNo,
    this.birthDate,
    this.gender,
    this.phoneNo,
    this.email,
  });
}

class AccountNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async => _loadProfile();

  Future<Profile> _loadProfile() async {
    final result = await ref.read(accountRepositoryProvider).getProfile();
    return result.fold(
      (failure) => throw failure,
      (profile) => profile,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadProfile);
  }

  Future<Failure?> updateProfile(UpdateProfileParams params) async {
    final result = await ref.read(accountRepositoryProvider).updateProfile(
      fullName: params.fullName,
      matricNo: params.matricNo,
      birthDate: params.birthDate,
      gender: params.gender,
      phoneNo: params.phoneNo,
      email: params.email,
    );
    return result.fold(
      (failure) => failure,
      (profile) {
        state = AsyncData(profile);
        return null;
      },
    );
  }
}
