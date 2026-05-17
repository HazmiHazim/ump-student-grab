class User {
  final int id;
  final String email;
  final String fullName;
  final String? gender;
  final String? birthDate;
  final String? matricNo;
  final String phoneNo;
  final String role;
  final int? attachmentId;
  // Driver-specific fields
  final String? icNo;
  final String? carBrand;
  final String? carModel;
  final String? plateNo;
  final String? carColour;
  final String? licenseType;
  final bool isVerified;
  final String token;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.gender,
    this.birthDate,
    this.matricNo,
    required this.phoneNo,
    required this.role,
    this.attachmentId,
    this.icNo,
    this.carBrand,
    this.carModel,
    this.plateNo,
    this.carColour,
    this.licenseType,
    required this.isVerified,
    required this.token,
  });

  bool get isDriver => role == 'DRIVER';
  bool get isPassenger => role == 'PASSENGER';
  bool get isAdmin => role == 'ADMIN';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      matricNo: json['matricNo'] as String?,
      phoneNo: json['phoneNo'] as String,
      role: json['role'] as String,
      attachmentId: json['attachmentId'] as int?,
      icNo: json['icNo'] as String?,
      carBrand: json['carBrand'] as String?,
      carModel: json['carModel'] as String?,
      plateNo: json['plateNo'] as String?,
      carColour: json['carColour'] as String?,
      licenseType: json['licenseType'] as String?,
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
        'icNo': icNo,
        'carBrand': carBrand,
        'carModel': carModel,
        'plateNo': plateNo,
        'carColour': carColour,
        'licenseType': licenseType,
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
    String? icNo,
    String? carBrand,
    String? carModel,
    String? plateNo,
    String? carColour,
    String? licenseType,
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
      icNo: icNo ?? this.icNo,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      plateNo: plateNo ?? this.plateNo,
      carColour: carColour ?? this.carColour,
      licenseType: licenseType ?? this.licenseType,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
    );
  }
}
