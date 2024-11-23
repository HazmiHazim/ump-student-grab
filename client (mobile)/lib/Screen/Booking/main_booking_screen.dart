import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainBookingScreen extends StatelessWidget {
  static const routeName = "/main-booking-screen";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Booking Screen", style: TextStyle(fontSize: 24)),
      );
  }
}