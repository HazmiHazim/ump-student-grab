import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/account/model/profile.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/notifier/account_notifier.dart';
import 'package:ump_student_grab_mobile/features/account/repository/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.read(dioProvider), ref.read(localStorageProvider));
});

final accountNotifierProvider = AsyncNotifierProvider<AccountNotifier, Profile>(
  AccountNotifier.new,
);
