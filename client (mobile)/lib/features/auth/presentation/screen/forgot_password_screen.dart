import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage('assets/images/forgot-password.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Forgot your password',
                          style: TextStyle(
                            color: Color.fromARGB(255, 75, 75, 75),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(
                            "Please enter the email associated with your account and we'll send you a password reset link.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 175, 175, 175),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomInput(
                          userInput: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                          onChanged: (_) => setState(() => _emailError = null),
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
                            onPressed: isLoading ? null : _handleForgotPassword,
                            child: isLoading
                                ? const CustomLoading()
                                : const Text(
                                    'Request Reset Link',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, color: AppColor.primary),
                              Text('Back to login',
                                  style: TextStyle(color: AppColor.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleForgotPassword() async {
    setState(() => _emailError = null);

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      return;
    }

    final result = await ref
        .read(authNotifierProvider.notifier)
        .forgotPassword(_emailController.text);

    if (!mounted) return;

    if (result.failure != null) {
      Fluttertoast.showToast(
        msg: result.failure!.message,
        backgroundColor: Colors.red.shade800,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: result.message ?? 'Reset link sent.',
        backgroundColor: Colors.green.shade800,
        textColor: Colors.white,
      );
    }
  }
}
