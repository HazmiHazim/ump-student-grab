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
}

class PlaceSuggestion {
  final String description;
  final String placeId;

  const PlaceSuggestion({required this.description, required this.placeId});
}
