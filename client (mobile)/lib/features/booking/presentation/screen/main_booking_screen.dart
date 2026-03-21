import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_booking_list_history.dart';

class MainBookingScreen extends StatelessWidget {
  const MainBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.transparentPrimary,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset('assets/images/book-now.png',
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Plan your journey now!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      backgroundColor: AppColor.primary,
                    ),
                    onPressed: () => context.push('/booking/map'),
                    child: const Text(
                      'Book now',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Text(
              'Past Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.sort, color: Colors.black, size: 30),
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
