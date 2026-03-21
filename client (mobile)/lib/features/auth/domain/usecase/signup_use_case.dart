import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SignupParams params) =>
      _repository.signup(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
        matricNo: params.matricNo,
        phoneNo: params.phoneNo,
        role: params.role,
      );
}

class SignupParams {
  final String email;
  final String password;
  final String fullName;
  final String matricNo;
  final String phoneNo;
  final String role;

  const SignupParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.matricNo,
    required this.phoneNo,
    required this.role,
  });
}
