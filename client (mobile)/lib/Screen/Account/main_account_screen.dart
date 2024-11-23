import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAccountScreen extends StatelessWidget {
  static const routeName = "/main-account-screen";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Account Screen", style: TextStyle(fontSize: 24)),
      );
  }
}