import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _socialButton(String imagePath, String label) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          width: 125,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Image.asset(imagePath, fit: BoxFit.fill),
              ),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(color: AppColor.primary)),
            ],
          ),
        ),
      ),
    );
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
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/login-2.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Welcome to UMPSA Student Grab!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 75, 75, 75),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Anytime, anywhere just for you',
                          style: TextStyle(
                            color: Color.fromARGB(255, 175, 175, 175),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        CustomInput(
                          userInput: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                          onChanged: (_) => setState(() => _emailError = null),
                        ),
                        const SizedBox(height: 5),
                        CustomInput(
                          userInput: _passwordController,
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          errorText: _passwordError,
                          onChanged: (_) => setState(() => _passwordError = null),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: AppColor.primary,
                            ),
                            onPressed: isLoading ? null : _handleLogin,
                            child: isLoading
                                ? const CustomLoading()
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: TextButton(
                            onPressed: () => context.push('/auth/forgot-password'),
                            child: const Text('Forgot password?',
                                style: TextStyle(color: AppColor.primary)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _socialButton('assets/images/google-logo.png', 'Google'),
                              _socialButton('assets/images/facebook-logo.png', 'Facebook'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 75, 75, 75))),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () => context.push('/auth/signup'),
                                child: const Text('Register',
                                    style: TextStyle(color: AppColor.primary)),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Future<void> _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      hasError = true;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'This field is required.');
      hasError = true;
    }
    if (_emailController.text.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      hasError = true;
    }
    if (hasError) return;

    final failure = await ref
        .read(authNotifierProvider.notifier)
        .login(_emailController.text, _passwordController.text);

    if (!mounted) return;

    if (failure != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(failure.message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        ),
      );
    }
    // Navigation is handled by go_router redirect
  }
}
