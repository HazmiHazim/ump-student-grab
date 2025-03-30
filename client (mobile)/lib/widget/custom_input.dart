import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController userInput;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final Function(String)? onChanged; // Add this

  const CustomInput({
    super.key,
    required this.userInput,
    required this.hintText,
    required this.keyboardType,
    this.obscureText = false,
    this.errorText,
    this.onChanged, // Add this
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 55,
          margin: EdgeInsets.only(bottom: widget.errorText != null ? 5 : 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 246, 246, 246),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: widget.userInput,
            autocorrect: false,
            enableSuggestions: false,
            autofocus: false,
            obscureText: _obscureText,
            cursorHeight: 16.0,
            cursorColor: const Color.fromRGBO(0, 159, 160, 100),
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 105, 105, 105)),
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 157, 157, 157)),
              floatingLabelStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 157, 157, 157)),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              )
                  : null,
            ),
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged, // This will remove error text when typing
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

