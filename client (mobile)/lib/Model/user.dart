class User {
  final int id;
  final String email;
  final String fullName;
  final String matricNo;
  final String phoneNo;
  final String role;
  final int attachmentId;
  final bool isVerified;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.matricNo,
    required this.phoneNo,
    required this.role,
    required this.attachmentId,
    required this.isVerified,
    required this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        matricNo: json["matricNo"],
        phoneNo: json["phoneNo"],
        role: json["role"],
        attachmentId: json["attachmentId"],
        isVerified: json["isVerified"],
      token: json["token"]
    );
  }
}