import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAccountList extends StatelessWidget {
  final double width;
  final double height;
  final IconData icon;
  final Color colour;
  final String title;

  const CustomAccountList({
    super.key,
    this.width = 50,
    this.height = 50,
    required this.icon,
    this.colour = Colors.grey,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: width,
        height: height,
        child: Icon(icon, color: colour),
        decoration: BoxDecoration(
          color: colour.withOpacity(0.09),
          borderRadius: BorderRadius.circular(18)
        ),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
    );
  }
}