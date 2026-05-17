import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/driver_signup_args.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/step_indicator.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1 — Personal Info
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _icNoController = TextEditingController();
  final _phoneNoController = TextEditingController();

  String? _emailError;
  String? _fullNameError;
  String? _icNoError;
  String? _phoneNoError;

  // Step 2 — Vehicle Info
  final _carBrandController = TextEditingController();
  final _carModelController = TextEditingController();
  final _plateNoController = TextEditingController();

  String? _selectedColour;
  String? _selectedLicenseType;

  String? _carBrandError;
  String? _carModelError;
  String? _plateNoError;
  String? _colourError;
  String? _licenseTypeError;

  static const _colours = [
    'White', 'Black', 'Silver', 'Grey', 'Red',
    'Blue', 'Green', 'Yellow', 'Orange', 'Brown',
  ];

  static const _licenseTypes = ['B', 'B2', 'D', 'DA', 'GDL'];

  static const _stepLabels = ['Personal', 'Vehicle', 'Password'];

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _icNoController.dispose();
    _phoneNoController.dispose();
    _carBrandController.dispose();
    _carModelController.dispose();
    _plateNoController.dispose();
    super.dispose();
  }

  void _goNext() => _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

  void _goPrev() => _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

  bool _validateStep1() {
    setState(() {
      _emailError = null;
      _fullNameError = null;
      _icNoError = null;
      _phoneNoError = null;
    });
    bool err = false;
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      err = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      err = true;
    }
    if (_fullNameController.text.isEmpty) {
      setState(() => _fullNameError = 'This field is required.');
      err = true;
    }
    if (_icNoController.text.isEmpty) {
      setState(() => _icNoError = 'This field is required.');
      err = true;
    } else if (!RegExp(r'^\d{12}$').hasMatch(_icNoController.text)) {
      setState(() =>
          _icNoError = 'IC number must be 12 digits (e.g. 990101012345).');
      err = true;
    }
    if (_phoneNoController.text.isEmpty) {
      setState(() => _phoneNoError = 'This field is required.');
      err = true;
    } else if (!RegExp(r'^(\+\d{1,3}[- ]?)?\d{10,11}$')
        .hasMatch(_phoneNoController.text)) {
      setState(() => _phoneNoError = 'Phone number must be 10 or 11 digits.');
      err = true;
    }
    return !err;
  }

  bool _validateStep2() {
    setState(() {
      _carBrandError = null;
      _carModelError = null;
      _plateNoError = null;
      _colourError = null;
      _licenseTypeError = null;
    });
    bool err = false;
    if (_carBrandController.text.isEmpty) {
      setState(() => _carBrandError = 'This field is required.');
      err = true;
    }
    if (_carModelController.text.isEmpty) {
      setState(() => _carModelError = 'This field is required.');
      err = true;
    }
    if (_plateNoController.text.isEmpty) {
      setState(() => _plateNoError = 'This field is required.');
      err = true;
    }
    if (_selectedColour == null) {
      setState(() => _colourError = 'Please select a car colour.');
      err = true;
    }
    if (_selectedLicenseType == null) {
      setState(() => _licenseTypeError = 'Please select a license type.');
      err = true;
    }
    return !err;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goPrev();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              StepIndicator(
                currentStep: _currentStep,
                totalSteps: 3,
                labels: _stepLabels,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentStep = i),
                  children: [
                    _buildPersonalInfoPage(),
                    _buildVehicleInfoPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 130),
            child: Image.asset(
              'assets/images/create-account-2.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Personal Information',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Text(
              'Provide your personal details to register as a driver.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 175, 175, 175),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: AppColor.primary,
              ),
              onPressed: () {
                if (_validateStep1()) _goNext();
              },
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
    );
  }

  Widget _buildVehicleInfoPage() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 130),
            child: Image.asset(
              'assets/images/create-account-2.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Vehicle Information',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Text(
              'Provide your vehicle details to complete registration.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 175, 175, 175),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            hint: 'Car Colour',
            items: _colours,
            value: _selectedColour,
            errorText: _colourError,
            onChanged: (v) => setState(() {
              _selectedColour = v;
              _colourError = null;
            }),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: AppColor.primary,
              ),
              onPressed: () {
                if (_validateStep2()) {
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
                      carColour: _selectedColour!,
                      licenseType: _selectedLicenseType!,
                    ),
                  );
                }
              },
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
            onPressed: _goPrev,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, color: AppColor.primary),
                Text('Back', style: TextStyle(color: AppColor.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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
                color: errorText != null
                    ? Colors.red
                    : Colors.grey.withValues(alpha: 0.4),
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
                onChanged: onChanged,
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
}
