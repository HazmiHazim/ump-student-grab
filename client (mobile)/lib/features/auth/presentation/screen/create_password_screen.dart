import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/signup_args.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  final SignupArgs args;
  const CreatePasswordScreen({super.key, required this.args});

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

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
                  'assets/images/create-password-2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Create Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 75, 75, 75),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password Requirements:',
                        style: TextStyle(
                            color: Color.fromARGB(255, 75, 75, 75),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    _Requirement('Password must be at least 6 characters long.'),
                    _Requirement('Password must contain at least 1 capital letter.'),
                    _Requirement('Password must contain at least 1 number.'),
                    _Requirement(r'Password must contain at least 1 special character (@,#,$,%,*).'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomInput(
                userInput: _passwordController,
                hintText: 'New Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                errorText: _passwordError,
                onChanged: (_) => setState(() => _passwordError = null),
              ),
              CustomInput(
                userInput: _confirmPasswordController,
                hintText: 'Confirm Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                errorText: _confirmPasswordError,
                onChanged: (_) => setState(() => _confirmPasswordError = null),
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
                  ),
                  onPressed: isLoading ? null : _handleSignup,
                  child: isLoading
                      ? const CustomLoading()
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/auth/login'),
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

  Future<void> _handleSignup() async {
    setState(() {
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool hasError = false;

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'This field is required.');
      hasError = true;
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'This field is required.');
      hasError = true;
    }
    if (_passwordController.text.isNotEmpty &&
        !RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$')
            .hasMatch(_passwordController.text)) {
      setState(
          () => _passwordError = 'Password does not meet the requirements.');
      hasError = true;
    }
    if (_confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Passwords do not match.');
      hasError = true;
    }
    if (hasError) return;

    final failure = await ref.read(authNotifierProvider.notifier).signup(
          email: widget.args.email,
          password: _passwordController.text,
          fullName: widget.args.fullName,
          matricNo: widget.args.matricNo,
          phoneNo: widget.args.phoneNo,
          role: 'student',
        );

    if (!mounted) return;

    if (failure != null) {
      Fluttertoast.showToast(
        msg: failure.message,
        backgroundColor: Colors.red.shade800,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Account created successfully. Please log in.',
        backgroundColor: Colors.green.shade800,
        textColor: Colors.white,
      );
      context.go('/auth/login');
    }
  }
}

class _Requirement extends StatelessWidget {
  final String text;
  const _Requirement(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('- ',
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
