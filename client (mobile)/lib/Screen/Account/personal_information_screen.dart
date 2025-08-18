import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';

class PersonalInformationScreen extends StatefulWidget {

  static const routeName = '/personal-information-screen';

  @override
  State<StatefulWidget> createState() => _PersonalInformationScreen();
}

class _PersonalInformationScreen extends State<PersonalInformationScreen> {
  final textInput1 = TextEditingController();
  final textInput2 = TextEditingController();

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
            const Text(
                "Personal details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold
                ),
                textAlign: TextAlign.start
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  CustomInput(
                    userInput: textInput1,
                    hintText: "Name",
                    keyboardType: TextInputType.text,
                    showBorder: true,
                    borderRadius: 10
                  ),
                  CustomInput(
                      userInput: textInput2,
                      hintText: "Date of birth",
                      keyboardType: TextInputType.datetime,
                      showBorder: true,
                      borderRadius: 10
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}