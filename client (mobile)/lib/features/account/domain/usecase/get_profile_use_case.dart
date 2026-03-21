import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';
import 'package:ump_student_grab_mobile/features/account/domain/repository/account_repository.dart';

class GetProfileUseCase implements UseCase<Profile, NoParams> {
  final AccountRepository _repository;
  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) =>
      _repository.getProfile();
}
