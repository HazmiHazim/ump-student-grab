import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/usecase/use_case.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/repository/booking_repository.dart';

class GetAutocompleteUseCase
    implements UseCase<List<PlaceSuggestion>, AutocompleteParams> {
  final BookingRepository _repository;
  GetAutocompleteUseCase(this._repository);

  @override
  Future<Either<Failure, List<PlaceSuggestion>>> call(
          AutocompleteParams params) =>
      _repository.autocomplete(params.query);
}

class AutocompleteParams {
  final String query;
  const AutocompleteParams({required this.query});
}
