import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class DriverRidesScreen extends StatelessWidget {
  const DriverRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_outlined,
              size: 72, color: AppColor.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'No ride requests yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Go online from Home to start receiving requests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 150, 150, 150),
            ),
          ),
        ],
      ),
    );
  }
}
