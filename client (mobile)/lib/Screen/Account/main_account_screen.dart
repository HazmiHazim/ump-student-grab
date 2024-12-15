import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/BL/account_service.dart';
import 'package:ump_student_grab_mobile/BL/auth_service.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:ump_student_grab_mobile/widget/custom_account_list.dart';
import '../../util/shared_preferences_util.dart';
import '../../widget/custom_loading.dart';

class MainAccountScreen extends StatefulWidget {
  static const routeName = "/main-account-screen";

  @override
  _MainAccountScreenState createState() => _MainAccountScreenState();
}

class _MainAccountScreenState extends State<MainAccountScreen> {

  // Fetch user ID from SharedPreferences
  Future<int?> _getCurrentUserImageId() async {
    final user = await SharedPreferencesUtil.loadUser();
    return user?.attachmentId; // Return the current user's ID
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: false,
      child: Column(
        children: [
          Container(height: 30),
          ListTile(
            leading: FutureBuilder<int?>(
              future: _getCurrentUserImageId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return CircleAvatar(
                    child: Icon(Icons.error),
                  );
                } else {
                  final attachmentId = snapshot.data;
                  // Now pass the resolved attachmentId to getImageProfile
                  return FutureBuilder<Uint8List?>(
                    future: Provider.of<AccountService>(context, listen: false)
                        .getUserImage(attachmentId!),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(child: CircularProgressIndicator());
                      } else if (imageSnapshot.hasError || !imageSnapshot.hasData) {
                        return CircleAvatar(child: Icon(Icons.error));
                      } else {
                        return CircleAvatar(
                          backgroundImage: MemoryImage(imageSnapshot.data!),
                        );
                      }
                    },
                  );
                }
              },
            ),
            title: Text("Hazmi Hazim"),
            subtitle: Text("Software Engineer"),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(thickness: 0.5),
          ),
          InkWell(
            onTap: () {},
            child: CustomAccountList(icon: Icons.person, title: "Personal Information", colour: Colors.deepPurpleAccent,)
          ),
          InkWell(
            onTap: () {},
            child: CustomAccountList(icon: Icons.settings, title: "Settings", colour: Colors.lightBlueAccent,)
          ),
          InkWell(
            onTap: () {},
            child: CustomAccountList(icon: Icons.credit_card, title: "Payment", colour: Colors.pinkAccent,)
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(thickness: 0.5),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: CustomAccountList(icon: Icons.info_rounded, title: "FAQs", colour: Colors.orangeAccent,)
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  showDialog(context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const Center(child: CustomLoading()));

                  // Retrieve token from SharedPreferences
                  final user = await SharedPreferencesUtil.loadUser(); // Assuming a method to load token
                  final token = user?.token;

                  AuthResponse response = await Provider.of<AuthService>(context, listen: false).logout(token!);

                  // Close the loading dialog after logout is complete
                  Navigator.of(context).pop();

                  if (response.isSuccess) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>  LoginScreen()));
                  } else {
                    showDialog(context: context, builder: (ctx) => AlertDialog(
                      title: Text(response.message, style: TextStyle(fontSize: 16)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text("CLOSE"),
                        ),
                      ],
                    ));
                  }
                },
                child: Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white,),),
              ),
            ),
          )
        ],
      ),
    );
  }
}