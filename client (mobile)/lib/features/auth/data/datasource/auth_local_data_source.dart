import 'package:ump_student_grab_mobile/core/storage/local_storage.dart';
import 'package:ump_student_grab_mobile/features/auth/data/model/user_model.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel model);
  Future<User?> getUser();
  Future<void> clearUser();
  Future<bool> isFirstTime();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _storage;
  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveUser(UserModel model) => _storage.saveUser(model.toJson());

  @override
  Future<User?> getUser() async {
    final json = await _storage.getUser();
    if (json == null) return null;
    return UserModel.fromJson(json).toEntity();
  }

  @override
  Future<void> clearUser() => _storage.clearUser();

  @override
  Future<bool> isFirstTime() => _storage.isFirstTime();
}
