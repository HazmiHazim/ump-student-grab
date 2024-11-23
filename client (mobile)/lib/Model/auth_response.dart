class AuthResponse {
  final int status;
  final int? userId;
  final bool isSuccess;
  final String message;

  AuthResponse({
    required this.status,
    required this.userId,
    required this.isSuccess,
    required this.message
  });

  // Factory constructor to create from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json["status"],
      userId: json["userId"],
      isSuccess: json["success"],
      message: json["message"],
    );
  }
}