import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController userInput;
  final String hintTitle;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;

  const CustomInput({
    super.key,
    required this.userInput,
    required this.hintTitle,
    required this.keyboardType,
    this.obscureText = false,
    this.errorText
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 55,
          margin: EdgeInsets.only(bottom: errorText != null ? 5 : 15),
          decoration: BoxDecoration(color: Colors.blueGrey.shade200, borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
            child: TextField(
              controller: userInput,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              obscureText: obscureText,
              decoration: InputDecoration.collapsed(
                hintText: hintTitle,
                hintStyle: TextStyle(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic),
              ),
              keyboardType: keyboardType,
            ),
          ),
        ),
        if (errorText != null)
          Text(
            errorText!,
            style: TextStyle(color: Colors.red, fontSize: 12), // Show error in red
          ),
      ],
    );
  }
}