import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBookingListHistory extends StatelessWidget {
  final int userId;
  final String fromLocation;
  final String toLocation;
  final DateTime bookingDate;

  const CustomBookingListHistory({
    super.key,
    required this.userId,
    required this.fromLocation,
    required this.toLocation,
    required this.bookingDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    fromLocation,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                Flexible(
                  child: Text(
                    toLocation,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(bookingDate),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            const Text(
              'Car → Ferrari  |  Plate: ABC 1234',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
