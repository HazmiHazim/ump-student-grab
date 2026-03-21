import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repository.logout();
}
