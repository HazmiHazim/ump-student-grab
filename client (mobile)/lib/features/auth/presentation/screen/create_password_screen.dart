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
  String _password = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
        _passwordError = null;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _password.length >= 6;
  bool get _hasUppercase => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasDigit => _password.contains(RegExp(r'\d'));
  bool get _hasSpecial => _password.contains(RegExp(r'[@#$%*]'));

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password Requirements:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _PasswordRule(
                      met: _hasMinLength,
                      text: 'At least 6 characters',
                      touched: _password.isNotEmpty,
                    ),
                    _PasswordRule(
                      met: _hasUppercase,
                      text: 'At least 1 uppercase letter',
                      touched: _password.isNotEmpty,
                    ),
                    _PasswordRule(
                      met: _hasDigit,
                      text: 'At least 1 number',
                      touched: _password.isNotEmpty,
                    ),
                    _PasswordRule(
                      met: _hasSpecial,
                      text: r'At least 1 special character (@, #, $, %, *)',
                      touched: _password.isNotEmpty,
                    ),
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
                onChanged: (_) {},
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

class _PasswordRule extends StatelessWidget {
  final bool met;
  final bool touched;
  final String text;

  const _PasswordRule({
    required this.met,
    required this.touched,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    if (!touched) {
      color = const Color.fromARGB(255, 175, 175, 175);
      icon = Icons.radio_button_unchecked;
    } else if (met) {
      color = Colors.green;
      icon = Icons.check_circle_rounded;
    } else {
      color = Colors.redAccent;
      icon = Icons.cancel_rounded;
    }

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(icon, key: ValueKey(icon), color: color, size: 15),
            ),
            const SizedBox(width: 6),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
