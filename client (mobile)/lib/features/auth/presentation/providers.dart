import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/auth/model/user.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:ump_student_grab_mobile/features/auth/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider), ref.read(localStorageProvider));
});

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
