class User {
  final int id;
  final String email;
  final String fullName;
  final String matricNo;
  final String phoneNo;
  final String role;
  final bool isVerified;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.matricNo,
    required this.phoneNo,
    required this.role,
    required this.isVerified
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        matricNo: json["matricNo"],
        phoneNo: json["phoneNo"],
        role: json["role"],
        isVerified: json["isVerified"]
    );
  }
}