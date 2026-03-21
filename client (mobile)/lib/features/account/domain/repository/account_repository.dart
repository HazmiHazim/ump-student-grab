import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/account/domain/entity/profile.dart';

abstract class AccountRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile({
    String? fullName,
    String? matricNo,
    String? birthDate,
    String? gender,
    String? phoneNo,
    String? email,
  });
}
