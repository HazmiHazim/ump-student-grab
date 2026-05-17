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
  final String token;

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
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      matricNo: json['matricNo'] as String,
      phoneNo: json['phoneNo'] as String,
      role: json['role'] as String,
      attachmentId: json['attachmentId'] as int?,
      isVerified: json['isVerified'] as bool,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
        'gender': gender,
        'birthDate': birthDate,
        'matricNo': matricNo,
        'phoneNo': phoneNo,
        'role': role,
        'attachmentId': attachmentId,
        'isVerified': isVerified,
        'token': token,
      };

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
    String? token,
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
      token: token ?? this.token,
    );
  }
}
