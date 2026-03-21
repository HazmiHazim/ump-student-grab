import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) =>
      _repository.forgotPassword(params.email);
}

class ForgotPasswordParams {
  final String email;
  const ForgotPasswordParams({required this.email});
}
