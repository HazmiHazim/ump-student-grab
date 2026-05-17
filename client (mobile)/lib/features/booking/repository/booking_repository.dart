import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ump_student_grab_mobile/core/error/failure.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/features/booking/model/place.dart';

class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  Future<Either<Failure, List<PlaceSuggestion>>> autocomplete(String query) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.placesAutocomplete,
        queryParameters: {'query': query, 'region': 'MY'},
      );
      final data = response.data['data'] as List<dynamic>;
      return Right(
        data.map((e) => PlaceSuggestion.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Autocomplete failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Place>>> searchByText(String query) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.placesSearch,
        queryParameters: {'query': query, 'region': 'MY'},
      );
      final data = response.data['data'] as List<dynamic>;
      return Right(
        data.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on DioException catch (e) {
      return Left(ServerFailure(
        e.response?.data['message'] as String? ?? 'Search failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, String?>> getDirections(
      String origin, String destination) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.placesDirections,
        queryParameters: {'origin': origin, 'destination': destination},
      );
      return Right(response.data['data']?['encodedPolyline'] as String?);
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
