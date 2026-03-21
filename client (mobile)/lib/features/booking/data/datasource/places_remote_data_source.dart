import 'package:dio/dio.dart';
import 'package:ump_student_grab_mobile/core/network/api_endpoints.dart';
import 'package:ump_student_grab_mobile/features/booking/data/model/place_model.dart';

abstract class PlacesRemoteDataSource {
  Future<List<PlaceSuggestionModel>> autocomplete(String query);
  Future<List<PlaceModel>> searchByText(String query);
  Future<String?> getDirections(String origin, String destination);
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  final Dio _dio;
  PlacesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlaceSuggestionModel>> autocomplete(String query) async {
    final response = await _dio.get(
      ApiEndpoints.placesAutocomplete,
      queryParameters: {'query': query, 'region': 'MY'},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) =>
            PlaceSuggestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PlaceModel>> searchByText(String query) async {
    final response = await _dio.get(
      ApiEndpoints.placesSearch,
      queryParameters: {'query': query, 'region': 'MY'},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => PlaceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<String?> getDirections(String origin, String destination) async {
    final response = await _dio.get(
      ApiEndpoints.placesDirections,
      queryParameters: {'origin': origin, 'destination': destination},
    );
    return response.data['data']?['encodedPolyline'] as String?;
  }
}
