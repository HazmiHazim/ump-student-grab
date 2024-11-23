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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
            image: AssetImage(
              "assets/images/login.jpg",
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 510,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 45),
                    CustomInput(
                        userInput: emailController,
                        hintTitle: "Email",
                        keyboardType: TextInputType.emailAddress,
                        errorText: emailError
                    ),
                    Container(
                      height: 55,
                      // for an exact replicate, remove the padding.
                      padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          backgroundColor: Colors.indigo.shade800,
                        ),
                        onPressed: () async {
                          // Reset error messages before validation
                          setState(() {
                            emailError = null;
                          });

                          bool hasError = false;

                          if (emailController.text.isEmpty) {
                            setState(() {
                              emailError = "This field is required.";
                            });
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
                        },
                        child: Text("Request Reset Link", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(child: Text("Back to login"),),
                    Divider(thickness: 0, color: Colors.white),
                    /*
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text('Don\'t have an account yet ? ', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),),
                    TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  ],
                ),
                  */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}