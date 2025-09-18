import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ump_student_grab_mobile/BL/account_service.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/Screen/shared_widget.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import 'package:ump_student_grab_mobile/widget/custom_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonalInformationScreen extends StatefulWidget {

  static const routeName = '/personal-information-screen';

  @override
  State<StatefulWidget> createState() => _PersonalInformationScreen();
}

class _PersonalInformationScreen extends State<PersonalInformationScreen> {
  final nameInput = TextEditingController();
  final matricNoInput = TextEditingController();
  final dateOfBirthInput = TextEditingController();
  final phoneNoInput = TextEditingController();
  final emailInput = TextEditingController();
  String? selectedGender;
  late Future<User?> userFuture;
  String? emailError;

  @override
  void initState() {
    super.initState();
    userFuture = SharedPreferencesUtil.loadUser().then((user) {
      if (user != null) {
        nameInput.text = user.fullName ?? "";
        matricNoInput.text = user.matricNo ?? "";
        dateOfBirthInput.text = user.matricNo ?? "";
        phoneNoInput.text = user.phoneNo ?? "";
        emailInput.text = user.email ?? "";
      }
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "Personal Information",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold
              )
          )
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const Text(
                      "Personal Details",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold
                      ),
                      textAlign: TextAlign.start
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: nameInput,
                    hintText: "Name",
                    keyboardType: TextInputType.text,
                    showBorder: true,
                    borderRadius: 10
                  ),
                  CustomInput(
                      userInput: matricNoInput,
                      hintText: "Matric No.",
                      keyboardType: TextInputType.text,
                      showBorder: true,
                      borderRadius: 10
                  ),
                  CustomInput(
                      userInput: dateOfBirthInput,
                      hintText: "Date of birth",
                      keyboardType: TextInputType.datetime,
                      showBorder: true,
                      borderRadius: 10
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomRadioButton(
                          label: "Male",
                          selected: selectedGender == "Male",
                          onChanged: (value) {
                            setState(() {
                              selectedGender = "Male";
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomRadioButton(
                          label: "Female",
                          selected: selectedGender == "Female",
                          onChanged: (value) {
                            setState(() {
                              selectedGender = "Female";
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(thickness: 0.5),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const Text(
                      "Contact Details",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold
                      ),
                      textAlign: TextAlign.start
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                      userInput: phoneNoInput,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.text,
                      showBorder: true,
                      borderRadius: 10
                  ),
                  CustomInput(
                    userInput: emailInput,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: emailError,
                    onChanged: (value) {
                      setState(() {
                        emailError = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColor.primary,
                  ),
                  onPressed: _handleSave,
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    // Reset error messages before validation
    setState(() {
      emailError = null;
    });

    bool hasError = false;

    if (emailInput.text.isEmpty) {
      setState(() => emailError = "This field is required.");
      hasError = true;
    }

    if (emailInput.text.isNotEmpty && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailInput.text)) {
      setState(() => emailError = "Please enter a valid email address.");
      hasError = true;
    }

    if (hasError) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CustomLoading()),
    );

    final user = await userFuture;

    AuthResponse response = await Provider.of<AccountService>(context, listen: false).updatePersonalInfo(
      nameInput.text,
      matricNoInput.text,
      phoneNoInput.text,
      emailInput.text
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