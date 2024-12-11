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

  Widget login(IconData icon) {
    return Container(
      height: 50,
      width: 115,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          TextButton(onPressed: () {}, child: Text("Login")),
        ],
      ),
    );
  }

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
                    CustomInput(
                      userInput: passwordController,
                      hintTitle: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      errorText: passwordError
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
                            passwordError = null;
                          });

                          bool hasError = false;

                          if (emailController.text.isEmpty) {
                            setState(() {
                              emailError = "This field is required.";
                            });
                            hasError = true;
                          }

                          if (passwordController.text.isEmpty) {
                            setState(() {
                              passwordError = "This field is required.";
                            });
                            hasError = true; // Stop further processing
                          }

                          if (hasError) {
                            return;
                          }

                          showDialog(context: context,
                              barrierDismissible: false,
                              builder: (ctx) => const Center(child: CustomLoading()));
                          AuthResponse response = await Provider.of<AuthService>(context, listen: false).login(
                              emailController.text,
                              passwordController.text
                          );

                          Navigator.of(context).pop();

                          if (response.isSuccess) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>  SharedWidget()));
                          } else {
                            showDialog(context: context, builder: (ctx) => AlertDialog(
                              title: Text(response.message, style: TextStyle(fontSize: 16)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text("CLOSE"),
                                ),
                              ],
                            ));
                          }
                        },
                        child: Text("Sign In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,),),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(child: InkWell(
                      onTap: () => Navigator.pushNamed(context, "/forgot-password-screen"),
                      child: Text("Forgot password ?"),
                    )),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          login(Icons.add),
                          login(Icons.book_online),
                        ],
                      ),
                    ),
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