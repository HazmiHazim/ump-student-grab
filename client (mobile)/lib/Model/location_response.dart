class LocationResponse {
  final int status;
  final int? userId;
  final double latitude;
  final double longitude;
  final String message;

  LocationResponse({
    required this.status,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.message
  });

  // Factory constructor to create from JSON
  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      status: json["status"],
      userId: json["userId"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      message: json["message"],
    );
  }
}