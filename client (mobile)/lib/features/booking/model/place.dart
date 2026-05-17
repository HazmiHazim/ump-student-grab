class Place {
  final String name;
  final String placeId;
  final double lat;
  final double lng;

  const Place({
    required this.name,
    required this.placeId,
    required this.lat,
    required this.lng,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}

class PlaceSuggestion {
  final String description;
  final String placeId;

  const PlaceSuggestion({required this.description, required this.placeId});

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      description: json['description'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
    );
  }
}
