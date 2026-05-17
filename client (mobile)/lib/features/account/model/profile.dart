import 'dart:typed_data';

class Profile {
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
  final Uint8List? avatarBytes;

  const Profile({
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
    this.avatarBytes,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
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
    );
  }

  Profile copyWith({
    String? email,
    String? fullName,
    String? gender,
    String? birthDate,
    String? matricNo,
    String? phoneNo,
    int? attachmentId,
    Uint8List? avatarBytes,
  }) {
    return Profile(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      matricNo: matricNo ?? this.matricNo,
      phoneNo: phoneNo ?? this.phoneNo,
      role: role,
      attachmentId: attachmentId ?? this.attachmentId,
      isVerified: isVerified,
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}
