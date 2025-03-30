import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';

class SignupScreen extends StatefulWidget {

  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final matricNoController = TextEditingController();
  final phoneNoController = TextEditingController();

  String? emailError;
  String? fullNameError;
  String? matricNoError;
  String? phoneNoError;

  // State to track button enable/disable status
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state
    emailController.addListener(_updateButtonState);
    fullNameController.addListener(_updateButtonState);
    matricNoController.addListener(_updateButtonState);
    phoneNoController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      // Enable button if all field is filled
      isButtonEnabled = emailController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          matricNoController.text.isNotEmpty &&
          phoneNoController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    fullNameController.dispose();
    matricNoController.dispose();
    phoneNoController.dispose();
    super.dispose();
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
                              image: AssetImage("assets/images/create-account-2.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Create Account",
                          style: TextStyle(
                              color: Color.fromARGB(255, 75, 75, 75),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Text(
                            "Please provide all required details to continue creating your account.",
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
                          const SizedBox(height: 5),
                          CustomInput(
                            userInput: fullNameController,
                            hintText: "Full Name",
                            keyboardType: TextInputType.text,
                            errorText: fullNameError,
                            onChanged: (value) {
                              setState(() {
                                fullNameError = null;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          CustomInput(
                            userInput: matricNoController,
                            hintText: "Matric No.",
                            keyboardType: TextInputType.text,
                            errorText: matricNoError,
                            onChanged: (value) {
                              setState(() {
                                matricNoError = null;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          CustomInput(
                            userInput: phoneNoController,
                            hintText: "Mobile Phone No.",
                            keyboardType: TextInputType.phone,
                            errorText: phoneNoError,
                            onChanged: (value) {
                              setState(() {
                                phoneNoError = null;
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
                                disabledBackgroundColor: const Color.fromRGBO(168, 196, 197, 100),
                              ),
                              onPressed: isButtonEnabled ? _handleFirstLayerSignup : null, // Disable if empty,
                              child: const Text(
                                "Next",
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

  void _handleFirstLayerSignup() async {
    // Reset error messages before validation
    setState(() {
      emailError = null;
      fullNameError = null;
      matricNoError = null;
      phoneNoError= null;
    });

    bool hasError = false;

    if (emailController.text.isEmpty) {
      setState(() => emailError = "This field is required.");
      hasError = true;
    }

    if (fullNameController.text.isEmpty) {
      setState(() => fullNameError = "This field is required.");
      hasError = true;
    }

    if (matricNoController.text.isEmpty) {
      setState(() => matricNoError = "This field is required.");
      hasError = true;
    }

    if (phoneNoController.text.isEmpty) {
      setState(() => phoneNoError = "This field is required.");
      hasError = true;
    }

    if (emailController.text.isNotEmpty && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text)) {
      setState(() => emailError = "Please enter a valid email address.");
      hasError = true;
    }

    if (matricNoController.text.isNotEmpty && !RegExp(r"^[A-Za-z]{2}\d{5}$").hasMatch(matricNoController.text)) {
      setState(() => matricNoError = "Please enter a valid matric number (e.g. CB12345).");
      hasError = true;
    }

    if (phoneNoController.text.isNotEmpty && !RegExp(r"^(\+\d{1,3}[- ]?)?\d{10,11}$").hasMatch(phoneNoController.text)) {
      setState(() => phoneNoError = "Phone number must be 10 or 11 digits.");
      hasError = true;
    }

    if (hasError) {
      return;
    }

    Navigator.pushNamed(
      context,
      "/create-password-screen",
      arguments: {
        "email": emailController.text,
        "fullName": fullNameController.text,
        "matricNo": matricNoController.text,
        "phoneNo": phoneNoController.text
      }
    );
  }
}