import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) =>
      _repository.login(params.email, params.password);
}

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}
