import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/features/booking/data/datasource/places_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/repository/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final PlacesRemoteDataSource _remote;
  BookingRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<PlaceSuggestion>>> autocomplete(String query) async {
    try {
      final results = await _remote.autocomplete(query);
      return Right(results);
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Autocomplete failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Place>>> searchByText(String query) async {
    try {
      final results = await _remote.searchByText(query);
      return Right(results);
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Search failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getDirections(
      String origin, String destination) async {
    try {
      final polyline = await _remote.getDirections(origin, destination);
      return Right(polyline);
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Directions failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
