import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/Screen/shared_widget.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import '../../BL/auth_service.dart';

class LoginScreen extends StatefulWidget {

  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  Widget login(String imagePath, String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          width: 125,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fill,
                    image: AssetImage(imagePath),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(text, style: const TextStyle(color: Color.fromRGBO(0, 159, 160, 100))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
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
                              alignment: Alignment.topCenter,
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/login-2.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Welcome to UMPSA Student Grab!",
                          style: TextStyle(
                            color: Color.fromARGB(255, 75, 75, 75),
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Anytime, anywhere just for you",
                          style: TextStyle(
                              color: Color.fromARGB(255, 175, 175, 175),
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        CustomInput(
                          userInput: emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          errorText: emailError,
                        ),
                        const SizedBox(height: 5),
                        CustomInput(
                          userInput: passwordController,
                          hintText: "Password",
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          errorText: passwordError,
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
                              backgroundColor: const Color.fromRGBO(0, 159, 160, 100),
                            ),
                            onPressed: _handleLogin,
                            child: const Text(
                              "Sign In",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, "/forgot-password-screen"),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: Color.fromRGBO(0, 159, 160, 100)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              login("assets/images/google-logo.png", "Google"),
                              login("assets/images/facebook-logo.png", "Facebook"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Register",
                                style: TextStyle(color: Color.fromRGBO(0, 159, 160, 100)),
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

  void _handleLogin() async {
    // Reset error messages before validation
    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool hasError = false;

    if (emailController.text.isEmpty) {
      setState(() => emailError = "This field is required.");
      hasError = true;
    }

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "This field is required.");
      hasError = true;
    }

    if (emailController.text.isNotEmpty && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text)) {
      setState(() => emailError = "Please enter a valid email address.");
      hasError = true;
    }

    if (hasError) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CustomLoading()),
    );

    AuthResponse response = await Provider.of<AuthService>(context, listen: false)
        .login(emailController.text, passwordController.text);

    Navigator.of(context).pop();

    if (response.isSuccess) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => SharedWidget()));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(response.message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("CLOSE"),
            ),
          ],
        ),
      );
    }
  }

}