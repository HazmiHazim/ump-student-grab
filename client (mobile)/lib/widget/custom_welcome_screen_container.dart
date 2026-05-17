import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

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
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
