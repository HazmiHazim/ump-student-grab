import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';
import 'package:ump_student_grab_mobile/features/account/domain/repository/account_repository.dart';

class UpdateProfileUseCase implements UseCase<Profile, UpdateProfileParams> {
  final AccountRepository _repository;
  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) =>
      _repository.updateProfile(
        fullName: params.fullName,
        matricNo: params.matricNo,
        birthDate: params.birthDate,
        gender: params.gender,
        phoneNo: params.phoneNo,
        email: params.email,
      );
}

class UpdateProfileParams {
  final String? fullName;
  final String? matricNo;
  final String? birthDate;
  final String? gender;
  final String? phoneNo;
  final String? email;

  const UpdateProfileParams({
    this.fullName,
    this.matricNo,
    this.birthDate,
    this.gender,
    this.phoneNo,
    this.email,
  });
}
