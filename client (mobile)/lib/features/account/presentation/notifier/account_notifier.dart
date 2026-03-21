import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';
import 'package:ump_student_grab_mobile/features/account/domain/usecase/get_profile_use_case.dart';
import 'package:ump_student_grab_mobile/features/account/domain/usecase/update_profile_use_case.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/providers.dart';

class AccountNotifier extends AsyncNotifier<Profile> {
  late GetProfileUseCase _getProfile;
  late UpdateProfileUseCase _updateProfile;

  @override
  Future<Profile> build() async {
    _getProfile = ref.read(getProfileUseCaseProvider);
    _updateProfile = ref.read(updateProfileUseCaseProvider);
    return _loadProfile();
  }

  Future<Profile> _loadProfile() async {
    final result = await _getProfile(const NoParams());
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
    final result = await _updateProfile(params);
    return result.fold(
      (failure) => failure,
      (profile) {
        state = AsyncData(profile);
        return null;
      },
    );
  }
}
