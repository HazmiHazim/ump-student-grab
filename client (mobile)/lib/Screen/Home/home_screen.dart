import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/widget/custom_search_bar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          CustomSearchBar(
            hintText: "Search places...",
          ),
        ],
      ),
    );
  }
}