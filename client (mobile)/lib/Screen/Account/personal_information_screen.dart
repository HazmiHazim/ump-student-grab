import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ump_student_grab_mobile/BL/account_service.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import 'package:ump_student_grab_mobile/widget/custom_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  String? emailError;
  String? matricNoError;
  String? phoneNoError;
  User? userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    User? response = await Provider.of<AccountService>(context, listen: false).getPersonalDetails();

    setState(() {
      if (response != null) {
        nameInput.text = response.fullName;
        matricNoInput.text = response.matricNo;
        phoneNoInput.text = response.phoneNo;
        emailInput.text = response.email;
        selectedGender = response.gender;

        if (response.birthDate != null && response.birthDate!.isNotEmpty) {
          final castedDate = DateFormat("yyyy-MM-dd").parse(response.birthDate!);
          dateOfBirthInput.text = DateFormat("dd/MM/yyyy").format(castedDate);
        } else {
          dateOfBirthInput.text = "";
        }
      }
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
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: matricNoInput,
                    hintText: "Matric No.",
                    keyboardType: TextInputType.text,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: matricNoError,
                    onChanged: (value) {
                      setState(() {
                        matricNoError = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: dateOfBirthInput,
                    hintText: "Date of birth",
                    isDatePicker: true,
                    keyboardType: TextInputType.datetime,
                    showBorder: true,
                    borderRadius: 10,
                    icon: const Icon(Icons.calendar_month_rounded),
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
                      SizedBox(width: 10),
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
            const SizedBox(height: 20),
            const Divider(thickness: 0.5),
            const SizedBox(height: 20),
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
                    keyboardType: TextInputType.phone,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: phoneNoError,
                    onChanged: (value) {
                      setState(() {
                        phoneNoError = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
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
                  child: const Text(
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
      matricNoError = null;
      phoneNoError= null;
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

    if (matricNoInput.text.isNotEmpty && !RegExp(r"^[A-Za-z]{2}\d{5}$").hasMatch(matricNoInput.text)) {
      setState(() => matricNoError = "Please enter a valid matric number (e.g. CB12345).");
      hasError = true;
    }

    if (phoneNoInput.text.isNotEmpty && !RegExp(r"^(\+\d{1,3}[- ]?)?\d{10,11}$").hasMatch(phoneNoInput.text)) {
      setState(() => phoneNoError = "Phone number must be 10 or 11 digits.");
      hasError = true;
    }

    if (hasError) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CustomLoading()),
    );

    final castedDate = DateFormat("dd/MM/yyyy").parse(dateOfBirthInput.text);
    final formattedDate = DateFormat("yyyy-MM-dd").format(castedDate);

    AuthResponse response = await Provider.of<AccountService>(context, listen: false).updatePersonalInfo(
      nameInput.text,
      matricNoInput.text,
      formattedDate,
      selectedGender,
      phoneNoInput.text,
      emailInput.text,
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