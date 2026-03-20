class PlaceResult {
  final String name;
  final String placeId;
  final double lat;
  final double lng;

  PlaceResult({
    required this.name,
    required this.placeId,
    required this.lat,
    required this.lng,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      name: json['name'] ?? '',
      placeId: json['placeId'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
