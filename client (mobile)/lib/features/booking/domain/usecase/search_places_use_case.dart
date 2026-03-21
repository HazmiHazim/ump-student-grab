import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/repository/booking_repository.dart';

class SearchPlacesUseCase implements UseCase<List<Place>, SearchPlacesParams> {
  final BookingRepository _repository;
  SearchPlacesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Place>>> call(SearchPlacesParams params) =>
      _repository.searchByText(params.query);
}

class SearchPlacesParams {
  final String query;
  const SearchPlacesParams({required this.query});
}
