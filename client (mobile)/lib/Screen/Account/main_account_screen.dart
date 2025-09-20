import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/BL/account_service.dart';
import 'package:ump_student_grab_mobile/BL/auth_service.dart';
import 'package:ump_student_grab_mobile/Model/auth_response.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:ump_student_grab_mobile/widget/custom_account_list.dart';
import '../../Model/user.dart';
import '../../util/shared_preferences_util.dart';
import '../../widget/custom_loading.dart';

class MainAccountScreen extends StatefulWidget {
  static const routeName = "/main-account-screen";

  @override
  _MainAccountScreenState createState() => _MainAccountScreenState();
}

class _MainAccountScreenState extends State<MainAccountScreen> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = SharedPreferencesUtil.loadUser(); // Load user once
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Error loading user data"));
          }

          final user = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 30),
              ListTile(
                leading: FutureBuilder<Uint8List?>(
                  future: Provider.of<AccountService>(context, listen: false)
                      .getUserImage(user.attachmentId!),
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
                ),
                title: Text(user.fullName),
                subtitle: Text("${user.role} - ${user.phoneNo}"),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(thickness: 0.5),
              ),
              InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, "/personal-information-screen");
                  setState(() {
                    _userFuture = SharedPreferencesUtil.loadUser();
                  });
                },
                child: const CustomAccountList(
                  icon: Icons.person,
                  title: "Personal Information",
                  colour: Colors.deepPurpleAccent,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const CustomAccountList(
                  icon: Icons.settings,
                  title: "Settings",
                  colour: Colors.lightBlueAccent,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const CustomAccountList(
                  icon: Icons.credit_card,
                  title: "Payment",
                  colour: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(thickness: 0.5),
              ),
              if (user.role.isNotEmpty && user.role.contains("Driver")) ...[
                InkWell(
                  onTap: () {},
                  child: const CustomAccountList(
                    icon: Icons.person_pin_circle,
                    title: "Driver Dashboard",
                    colour: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(thickness: 0.5),
                ),
              ],
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                child: const CustomAccountList(
                  icon: Icons.info_rounded,
                  title: "FAQs",
                  colour: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {},
                child: const CustomAccountList(
                  icon: Icons.help,
                  title: "Help",
                  colour: Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => const Center(child: CustomLoading()),
                      );

                      AuthResponse response =
                      await Provider.of<AuthService>(context, listen: false)
                          .logout();

                      Navigator.of(context).pop(); // Close loading dialog

                      if (response.isSuccess) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => LoginScreen()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              response.message,
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text("CLOSE"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
