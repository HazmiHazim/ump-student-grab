class Location {
  final int userId;
  final double latitude;
  final double longitude;

  Location({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        userId: json["userId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );
  }
}