import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/signup_args.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _matricNoController = TextEditingController();
  final _phoneNoController = TextEditingController();

  String? _emailError;
  String? _fullNameError;
  String? _matricNoError;
  String? _phoneNoError;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _emailController,
      _fullNameController,
      _matricNoController,
      _phoneNoController,
    ]) {
      c.addListener(_updateButtonState);
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _fullNameController.text.isNotEmpty &&
          _matricNoController.text.isNotEmpty &&
          _phoneNoController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _matricNoController.dispose();
    _phoneNoController.dispose();
    super.dispose();
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
                constraints: const BoxConstraints(maxHeight: 160),
                child: Image.asset(
                  'assets/images/create-account-2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Create Account',
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
                  'Please provide all required details to continue creating your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 175, 175, 175),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomInput(
                userInput: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) => setState(() => _emailError = null),
              ),
              CustomInput(
                userInput: _fullNameController,
                hintText: 'Full Name',
                keyboardType: TextInputType.text,
                errorText: _fullNameError,
                onChanged: (_) => setState(() => _fullNameError = null),
              ),
              CustomInput(
                userInput: _matricNoController,
                hintText: 'Matric No.',
                keyboardType: TextInputType.text,
                errorText: _matricNoError,
                onChanged: (_) => setState(() => _matricNoError = null),
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
                onPressed: () => context.push('/auth/driver-signup'),
                child: const Text(
                  'Register as Driver instead',
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

  void _handleNext() {
    setState(() {
      _emailError = null;
      _fullNameError = null;
      _matricNoError = null;
      _phoneNoError = null;
    });

    bool hasError = false;

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      hasError = true;
    }
    if (_fullNameController.text.isEmpty) {
      setState(() => _fullNameError = 'This field is required.');
      hasError = true;
    }
    if (_matricNoController.text.isEmpty) {
      setState(() => _matricNoError = 'This field is required.');
      hasError = true;
    }
    if (_phoneNoController.text.isEmpty) {
      setState(() => _phoneNoError = 'This field is required.');
      hasError = true;
    }
    if (_emailController.text.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      hasError = true;
    }
    if (_matricNoController.text.isNotEmpty &&
        !RegExp(r'^[A-Za-z]{2}\d{5}$').hasMatch(_matricNoController.text)) {
      setState(() =>
          _matricNoError = 'Please enter a valid matric number (e.g. CB12345).');
      hasError = true;
    }
    if (_phoneNoController.text.isNotEmpty &&
        !RegExp(r'^(\+\d{1,3}[- ]?)?\d{10,11}$')
            .hasMatch(_phoneNoController.text)) {
      setState(() => _phoneNoError = 'Phone number must be 10 or 11 digits.');
      hasError = true;
    }
    if (hasError) return;

    context.push(
      '/auth/create-password',
      extra: SignupArgs(
        email: _emailController.text,
        fullName: _fullNameController.text,
        matricNo: _matricNoController.text,
        phoneNo: _phoneNoController.text,
      ),
    );
  }
}
