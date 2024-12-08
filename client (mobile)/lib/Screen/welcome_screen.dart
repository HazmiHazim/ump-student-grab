import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ump_student_grab_mobile/widget/custom_welcome_screen_container.dart';

class WelcomeScreen extends StatefulWidget {

  static const routeName = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 3;
            });
          },
          children: [
            // First view
            CustomWelcomeScreenContainer(
                color: Colors.white,
                title: "Explore New Application with UMPSA Student Grab",
                subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                imagePath: "assets/images/welcome-1.png"
            ),

            // Second view
            CustomWelcomeScreenContainer(
                color: Colors.white,
                title: "Your Ride, Your Schedule",
                subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                imagePath: "assets/images/welcome-2.png"
            ),

            // Third view
            CustomWelcomeScreenContainer(
                color: Colors.white,
                title: "Campus Commute Made Easy",
                subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                imagePath: "assets/images/welcome-3.png"
            ),

            // Last view
            CustomWelcomeScreenContainer(
                color: Colors.white,
                title: "Exclusive Student Rides at Unbeatable Prices",
                subtitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                imagePath: "assets/images/welcome-4.png"
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage ? Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              backgroundColor: Color.fromRGBO(0, 159, 160, 100),
              minimumSize: const Size.fromHeight(60)
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>  LoginScreen()));
            },
            child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 20, color: Colors.white))
          ),
        ),
      ) : Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text button for skip
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>  LoginScreen()));
                },
                child: Text("Skip", style: TextStyle(fontSize: 18))
            ),

            // Text button for next
            Center(
              child: SmoothPageIndicator(
                effect: WormEffect(
                  spacing: 15,
                  dotColor: Colors.blueGrey.shade300,
                  activeDotColor: Color.fromRGBO(0, 159, 160, 100),
                ),
                controller: pageController,
                count: 4
              ),
            ),
            TextButton(
                onPressed: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut
                  );
                },
                child: Text("Next", style: TextStyle(fontSize: 18))
            ),
          ],
        ),
      ),
    );
  }
}