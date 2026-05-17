import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_booking_list_history.dart';

class MainBookingScreen extends StatelessWidget {
  const MainBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.35,
            decoration: const BoxDecoration(
              color: AppColor.transparentPrimary,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Image.asset(
                    'assets/images/book-now.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Plan your journey now!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      backgroundColor: AppColor.primary,
                    ),
                    onPressed: () => context.push('/rides/map'),
                    child: const Text(
                      'Book now',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const ListTile(
            leading: Text(
              'Past Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.sort, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 10),
          CustomBookingListHistory(
              userId: 1,
              fromLocation: 'Perak',
              toLocation: 'Kuala Lumpur',
              bookingDate: DateTime.now()),
          CustomBookingListHistory(
              userId: 1,
              fromLocation: 'Perak',
              toLocation: 'Kuala Lumpur',
              bookingDate: DateTime.now()),
          CustomBookingListHistory(
              userId: 1,
              fromLocation: 'Perak',
              toLocation: 'Kuala Lumpur',
              bookingDate: DateTime.now()),
        ],
      ),
    );
  }
}
