import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/account/data/datasource/account_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/account/data/repository/account_repository_impl.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';
import 'package:ump_student_grab_mobile/features/account/domain/repository/account_repository.dart';
import 'package:ump_student_grab_mobile/features/account/domain/usecase/get_profile_use_case.dart';
import 'package:ump_student_grab_mobile/features/account/domain/usecase/update_profile_use_case.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/notifier/account_notifier.dart';

final accountRemoteDataSourceProvider = Provider<AccountRemoteDataSource>((ref) {
  return AccountRemoteDataSourceImpl(ref.read(dioProvider));
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(
    ref.read(accountRemoteDataSourceProvider),
    ref.read(localStorageProvider),
  );
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(accountRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(accountRepositoryProvider));
});

final accountNotifierProvider = AsyncNotifierProvider<AccountNotifier, Profile>(
  AccountNotifier.new,
);
