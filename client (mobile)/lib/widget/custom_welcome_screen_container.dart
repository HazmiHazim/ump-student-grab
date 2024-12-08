import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWelcomeScreenContainer extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String imagePath;

  const CustomWelcomeScreenContainer({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.imagePath
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10,),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 26,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.black,
                fontSize: 17
              ),
            ),
          )
        ],
      ),
    );
  }

}