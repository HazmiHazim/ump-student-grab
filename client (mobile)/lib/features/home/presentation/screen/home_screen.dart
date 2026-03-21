import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/widget/custom_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          CustomSearchBar(hintText: 'Search places...'),
        ],
      ),
    );
  }
}
