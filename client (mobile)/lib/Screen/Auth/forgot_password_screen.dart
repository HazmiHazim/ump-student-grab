import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import '../../BL/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {

  static const routeName = '/forgot-password-screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  String? emailError;

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
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.topCenter,
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/forgot-password.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Forgot your password",
                          style: TextStyle(
                              color: Color.fromARGB(255, 75, 75, 75),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(
                            "Please enter the email associated with your account and we'll send you password reset link.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 175, 175, 175),
                                fontSize: 14,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomInput(
                            userInput: emailController,
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            errorText: emailError,
                            onChanged: (value) {
                              setState(() {
                                emailError = null;
                              });
                            },
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
                              onPressed: _handleForgotPassword,
                              child: const Text(
                                "Request Reset Link",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pushNamed(context, "/login-screen");
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.arrow_back, color: Color.fromRGBO(0, 159, 160, 100)),
                                      Text(
                                        "Back to login",
                                        style: TextStyle(color: Color.fromRGBO(0, 159, 160, 100))
                                      )
                                    ],
                                  )
                              )
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

  void _handleForgotPassword() async {
    // Reset error messages before validation
    setState(() {
      emailError = null;
    });

    bool hasError = false;

    if (emailController.text.isEmpty) {
      setState(() => emailError = "This field is required.");
      hasError = true;
    }

    if (emailController.text.isNotEmpty && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text)) {
      setState(() => emailError = "Please enter a valid email address.");
      hasError = true;
    }

    if (hasError) {
      return;
    }

    showDialog(context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CustomLoading()));
    AuthResponse response = await Provider.of<AuthService>(context, listen: false).forgotPassword(
      emailController.text,
    );

    Navigator.of(context).pop();

    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green.shade800,
          textColor: Colors.white,
          fontSize: 12.0
      );
    } else {
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red.shade800,
          textColor: Colors.white,
          fontSize: 12.0
      );
    }
  }
}