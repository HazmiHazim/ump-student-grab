class User {
  final int id;
  final String email;
  final String fullName;
  final String? gender;
  final String? birthDate;
  final String matricNo;
  final String phoneNo;
  final String role;
  final int? attachmentId;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.gender,
    this.birthDate,
    required this.matricNo,
    required this.phoneNo,
    required this.role,
    this.attachmentId,
    required this.isVerified,
  });

  User copyWith({
    int? id,
    String? email,
    String? fullName,
    String? gender,
    String? birthDate,
    String? matricNo,
    String? phoneNo,
    String? role,
    int? attachmentId,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      matricNo: matricNo ?? this.matricNo,
      phoneNo: phoneNo ?? this.phoneNo,
      role: role ?? this.role,
      attachmentId: attachmentId ?? this.attachmentId,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
