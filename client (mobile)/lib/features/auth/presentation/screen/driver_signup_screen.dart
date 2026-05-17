import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/driver_signup_args.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _icNoController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _carBrandController = TextEditingController();
  final _carModelController = TextEditingController();
  final _plateNoController = TextEditingController();

  String? _selectedPrimaryColour;
  String? _selectedSecondaryColour;
  String? _selectedLicenseType;

  String? _emailError;
  String? _fullNameError;
  String? _icNoError;
  String? _phoneNoError;
  String? _carBrandError;
  String? _carModelError;
  String? _plateNoError;
  String? _primaryColourError;
  String? _licenseTypeError;

  bool _isButtonEnabled = false;

  static const _colours = [
    'White', 'Black', 'Silver', 'Grey', 'Red',
    'Blue', 'Green', 'Yellow', 'Orange', 'Brown',
  ];

  static const _licenseTypes = ['B', 'B2', 'D', 'DA', 'GDL'];

  @override
  void initState() {
    super.initState();
    for (final c in [
      _emailController,
      _fullNameController,
      _icNoController,
      _phoneNoController,
      _carBrandController,
      _carModelController,
      _plateNoController,
    ]) {
      c.addListener(_updateButtonState);
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _fullNameController.text.isNotEmpty &&
          _icNoController.text.isNotEmpty &&
          _phoneNoController.text.isNotEmpty &&
          _carBrandController.text.isNotEmpty &&
          _carModelController.text.isNotEmpty &&
          _plateNoController.text.isNotEmpty &&
          _selectedPrimaryColour != null &&
          _selectedLicenseType != null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _icNoController.dispose();
    _phoneNoController.dispose();
    _carBrandController.dispose();
    _carModelController.dispose();
    _plateNoController.dispose();
    super.dispose();
  }

  Widget _dropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.grey.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(hint, style: TextStyle(color: Colors.grey.shade500)),
                value: value,
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  onChanged(v);
                  _updateButtonState();
                },
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 140),
                child: Image.asset(
                  'assets/images/create-account-2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Register as Driver',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 75, 75, 75),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12, left: 20, right: 20),
                child: Text(
                  'Please provide your personal and vehicle details to register as a driver.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 175, 175, 175),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _sectionLabel('Personal Information'),
              CustomInput(
                userInput: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) => setState(() => _emailError = null),
              ),
              CustomInput(
                userInput: _fullNameController,
                hintText: 'Full Name (as per IC)',
                keyboardType: TextInputType.text,
                errorText: _fullNameError,
                onChanged: (_) => setState(() => _fullNameError = null),
              ),
              CustomInput(
                userInput: _icNoController,
                hintText: 'IC Number (e.g. 990101012345)',
                keyboardType: TextInputType.number,
                errorText: _icNoError,
                onChanged: (_) => setState(() => _icNoError = null),
              ),
              CustomInput(
                userInput: _phoneNoController,
                hintText: 'Mobile Phone No.',
                keyboardType: TextInputType.phone,
                errorText: _phoneNoError,
                onChanged: (_) => setState(() => _phoneNoError = null),
              ),
              const SizedBox(height: 8),
              _sectionLabel('Vehicle Information'),
              CustomInput(
                userInput: _carBrandController,
                hintText: 'Car Brand (e.g. Toyota)',
                keyboardType: TextInputType.text,
                errorText: _carBrandError,
                onChanged: (_) => setState(() => _carBrandError = null),
              ),
              CustomInput(
                userInput: _carModelController,
                hintText: 'Car Model (e.g. Vios)',
                keyboardType: TextInputType.text,
                errorText: _carModelError,
                onChanged: (_) => setState(() => _carModelError = null),
              ),
              CustomInput(
                userInput: _plateNoController,
                hintText: 'Plate No. (e.g. ABC1234)',
                keyboardType: TextInputType.text,
                errorText: _plateNoError,
                onChanged: (_) => setState(() => _plateNoError = null),
              ),
              _dropdown(
                hint: 'Primary Car Colour',
                items: _colours,
                value: _selectedPrimaryColour,
                errorText: _primaryColourError,
                onChanged: (v) => setState(() {
                  _selectedPrimaryColour = v;
                  _primaryColourError = null;
                }),
              ),
              _dropdown(
                hint: 'Secondary Car Colour (optional)',
                items: _colours,
                value: _selectedSecondaryColour,
                onChanged: (v) => setState(() => _selectedSecondaryColour = v),
              ),
              _dropdown(
                hint: 'License Type',
                items: _licenseTypes,
                value: _selectedLicenseType,
                errorText: _licenseTypeError,
                onChanged: (v) => setState(() {
                  _selectedLicenseType = v;
                  _licenseTypeError = null;
                }),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: AppColor.primary,
                    disabledBackgroundColor: AppColor.greyPrimary,
                  ),
                  onPressed: _isButtonEnabled ? _handleNext : null,
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/auth/signup'),
                child: const Text(
                  'Register as Passenger instead',
                  style: TextStyle(color: AppColor.primary),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/auth/login'),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: AppColor.primary),
                    Text('Back to login',
                        style: TextStyle(color: AppColor.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 75, 75, 75),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleNext() {
    setState(() {
      _emailError = null;
      _fullNameError = null;
      _icNoError = null;
      _phoneNoError = null;
      _carBrandError = null;
      _carModelError = null;
      _plateNoError = null;
      _primaryColourError = null;
      _licenseTypeError = null;
    });

    bool hasError = false;

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      hasError = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      hasError = true;
    }
    if (_fullNameController.text.isEmpty) {
      setState(() => _fullNameError = 'This field is required.');
      hasError = true;
    }
    if (_icNoController.text.isEmpty) {
      setState(() => _icNoError = 'This field is required.');
      hasError = true;
    } else if (!RegExp(r'^\d{12}$').hasMatch(_icNoController.text)) {
      setState(() => _icNoError = 'IC number must be 12 digits (e.g. 990101012345).');
      hasError = true;
    }
    if (_phoneNoController.text.isEmpty) {
      setState(() => _phoneNoError = 'This field is required.');
      hasError = true;
    } else if (!RegExp(r'^(\+\d{1,3}[- ]?)?\d{10,11}$')
        .hasMatch(_phoneNoController.text)) {
      setState(() => _phoneNoError = 'Phone number must be 10 or 11 digits.');
      hasError = true;
    }
    if (_carBrandController.text.isEmpty) {
      setState(() => _carBrandError = 'This field is required.');
      hasError = true;
    }
    if (_carModelController.text.isEmpty) {
      setState(() => _carModelError = 'This field is required.');
      hasError = true;
    }
    if (_plateNoController.text.isEmpty) {
      setState(() => _plateNoError = 'This field is required.');
      hasError = true;
    }
    if (_selectedPrimaryColour == null) {
      setState(() => _primaryColourError = 'Please select a primary colour.');
      hasError = true;
    }
    if (_selectedLicenseType == null) {
      setState(() => _licenseTypeError = 'Please select a license type.');
      hasError = true;
    }
    if (hasError) return;

    final colour = _selectedSecondaryColour != null
        ? '$_selectedPrimaryColour / $_selectedSecondaryColour'
        : _selectedPrimaryColour!;

    context.push(
      '/auth/driver-create-password',
      extra: DriverSignupArgs(
        email: _emailController.text,
        fullName: _fullNameController.text,
        icNo: _icNoController.text,
        phoneNo: _phoneNoController.text,
        carBrand: _carBrandController.text,
        carModel: _carModelController.text,
        plateNo: _plateNoController.text.toUpperCase(),
        carColour: colour,
        licenseType: _selectedLicenseType!,
      ),
    );
  }
}
