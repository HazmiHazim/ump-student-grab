import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBookingListHistory extends StatelessWidget {
  final int userId;
  final String fromLocation;
  final String toLocation;
  final DateTime bookingDate;
  final double width;
  final double height;
  final double padding;

  const CustomBookingListHistory({
    super.key,
    required this.userId,
    required this.fromLocation,
    required this.toLocation,
    required this.bookingDate,
    this.width = double.infinity,
    this.height = 100,
    this.padding = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400, // Grey color for the bottom border
              width: 0.5, // Border thickness
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  fromLocation,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 14, // Adjust icon size
                  color: Colors.black, // Optional: adjust icon color
                ),
                Text(
                  toLocation,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(bookingDate.toString()),
            Text("Car -> Ferrari | No Plate -> ABC1234"),
          ],
        ),
      )
    );
  }
}