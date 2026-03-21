import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<PlaceSuggestion>>> autocomplete(String query);
  Future<Either<Failure, List<Place>>> searchByText(String query);
  Future<Either<Failure, String?>> getDirections(String origin, String destination);
}
