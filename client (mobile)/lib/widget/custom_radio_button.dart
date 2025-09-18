import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class CustomRadioButton extends StatefulWidget {
  final String label;
  final double? width;
  final double? height;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const CustomRadioButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    this.selected = false,
    required this.onChanged,
  });

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(true);
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 246, 246, 246),
          border: Border.all(color: Colors.black54, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 105, 105, 105)),
              ),
              Radio(
                value: true,
                groupValue: widget.selected,
                activeColor: AppColor.primary,
                onChanged: (value) {
                  if (value != null) {
                    widget.onChanged(value);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}