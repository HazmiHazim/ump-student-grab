import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../BL/auth_service.dart';

class CreatePasswordScreen extends StatefulWidget {

  static const routeName = '/create-password-screen';

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    // Get the passing data from previous page
    final args = ModalRoute.of(context)!.settings.arguments as Map;

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
                              image: AssetImage("assets/images/create-password-2.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Create Password",
                          style: TextStyle(
                              color: Color.fromARGB(255, 75, 75, 75),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password Requirements:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 75, 75, 75),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "-",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Password must be at least 6 characters long.",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "-",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Password must contain at least 1 capital letter.",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "-",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Password must contain at least 1 number.",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "-",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        r"Password must contain at least 1 special character (@,#,$,%,*).",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
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
                  Expanded(
                    flex:1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomInput(
                          userInput: passwordController,
                          hintText: "New Password",
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          errorText: passwordError,
                          onChanged: (value) {
                            setState(() {
                              passwordError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        CustomInput(
                          userInput: confirmPasswordController,
                          hintText: "Confirm Password",
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          errorText: confirmPasswordError,
                          onChanged: (value) {
                            setState(() {
                              confirmPasswordError = null;
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
                              backgroundColor: AppColor.primary,
                            ),
                            onPressed: () {
                              _handleRegistration(args["email"], args["fullName"], args["matricNo"], args["phoneNo"]);
                            },
                            child: const Text(
                              "Sign Up",
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
                                    Icon(Icons.arrow_back, color: AppColor.primary),
                                    Text(
                                        "Back to login",
                                        style: TextStyle(color: AppColor.primary)
                                    )
                                  ],
                                )
                            )
                          ],
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

  void _handleRegistration(String email, String fullName, String matricNo, String phoneNo) async {
    // Reset error messages before validation
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
    });

    bool hasError = false;

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "This field is required.");
      hasError = true;
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() => confirmPasswordError = "This field is required.");
      hasError = true;
    }

    if (passwordController.text.isNotEmpty && !RegExp(r"^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$").hasMatch(passwordController.text)) {
      setState(() => passwordError = "Password does not meet the requirements.");
      hasError = true;
    }

    if (confirmPasswordController.text.isNotEmpty && confirmPasswordController.text != passwordController.text) {
      setState(() => confirmPasswordError = "Passwords do not match.");
      hasError = true;
    }

    if (hasError) return;

    showDialog(context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CustomLoading()));

    AuthResponse response = await Provider.of<AuthService>(context, listen: false).signup(
      email,
      passwordController.text,
      fullName,
      matricNo,
      phoneNo,
      "student"
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

      // Go to login page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
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