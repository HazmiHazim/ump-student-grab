class DriverSignupArgs {
  final String email;
  final String fullName;
  final String icNo;
  final String phoneNo;
  final String carBrand;
  final String carModel;
  final String plateNo;
  final String carColour;
  final String licenseType;

  const DriverSignupArgs({
    required this.email,
    required this.fullName,
    required this.icNo,
    required this.phoneNo,
    required this.carBrand,
    required this.carModel,
    required this.plateNo,
    required this.carColour,
    required this.licenseType,
  });
}
