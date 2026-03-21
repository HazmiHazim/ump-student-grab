import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';

class UserModel {
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

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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

  User toEntity() => User(
        id: id,
        email: email,
        fullName: fullName,
        gender: gender,
        birthDate: birthDate,
        matricNo: matricNo,
        phoneNo: phoneNo,
        role: role,
        attachmentId: attachmentId,
        isVerified: isVerified,
      );

  static UserModel fromEntity(User user, String token) => UserModel(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        gender: user.gender,
        birthDate: user.birthDate,
        matricNo: user.matricNo,
        phoneNo: user.phoneNo,
        role: user.role,
        attachmentId: user.attachmentId,
        isVerified: user.isVerified,
        token: token,
      );
}
