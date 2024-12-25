import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/widget/custom_booking_list_history.dart';

class MainBookingScreen extends StatelessWidget {
  static const routeName = "/main-booking-screen";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 159, 160, 245),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    "assets/images/book-now.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Plan your journey now!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: const Color.fromRGBO(0, 159, 160, 100),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/map-screen");
                    },
                    child: const Text(
                      "Book now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Text(
              "Past Bookings",
              style: TextStyle(
                fontSize: 18,  // Set the desired font size
                fontWeight: FontWeight.bold
              ),
            ),
            trailing: Icon(
              Icons.sort,
              color: Colors.black,
              size: 30,  // Set the desired icon size
            ),
          ),
          const SizedBox(height: 10),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
          CustomBookingListHistory(userId: 1, fromLocation: "Perak", toLocation: "Kuala Lumpur", bookingDate: DateTime.now()),
        ],
      ),
    );
  }
}