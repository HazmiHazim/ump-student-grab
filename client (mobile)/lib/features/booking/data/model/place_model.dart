import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';

class PlaceModel {
  final String name;
  final String placeId;
  final double lat;
  final double lng;

  const PlaceModel({
    required this.name,
    required this.placeId,
    required this.lat,
    required this.lng,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Place toEntity() => Place(name: name, placeId: placeId, lat: lat, lng: lng);
}

class PlaceSuggestionModel {
  final String description;
  final String placeId;

  const PlaceSuggestionModel(
      {required this.description, required this.placeId});

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestionModel(
      description: json['description'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
    );
  }

  PlaceSuggestion toEntity() =>
      PlaceSuggestion(description: description, placeId: placeId);
}
