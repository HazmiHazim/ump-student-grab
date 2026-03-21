import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/repository/booking_repository.dart';

class GetDirectionsUseCase implements UseCase<String?, DirectionsParams> {
  final BookingRepository _repository;
  GetDirectionsUseCase(this._repository);

  @override
  Future<Either<Failure, String?>> call(DirectionsParams params) =>
      _repository.getDirections(params.origin, params.destination);
}

class DirectionsParams {
  final String origin;
  final String destination;
  const DirectionsParams({required this.origin, required this.destination});
}
