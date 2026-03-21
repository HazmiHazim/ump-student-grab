import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ump_student_grab_mobile/router/app_router.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_welcome_screen_container.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _isLastPage = index == 3),
          children: const [
            CustomWelcomeScreenContainer(
              color: Colors.white,
              title: 'Explore New Application with UMPSA Student Grab',
              subtitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              imagePath: 'assets/images/welcome-1.png',
            ),
            CustomWelcomeScreenContainer(
              color: Colors.white,
              title: 'Your Ride, Your Schedule',
              subtitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              imagePath: 'assets/images/welcome-2.png',
            ),
            CustomWelcomeScreenContainer(
              color: Colors.white,
              title: 'Campus Commute Made Easy',
              subtitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              imagePath: 'assets/images/welcome-3.png',
            ),
            CustomWelcomeScreenContainer(
              color: Colors.white,
              title: 'Exclusive Student Rides at Unbeatable Prices',
              subtitle: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              imagePath: 'assets/images/welcome-4.png',
            ),
          ],
        ),
      ),
      bottomSheet: _isLastPage
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: AppColor.primary,
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: () {
                    ref.read(routerNotifierProvider).welcomeDone();
                    context.go('/auth/login');
                  },
                  child: const Text('Get Started',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              height: 80,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      ref.read(routerNotifierProvider).welcomeDone();
                      context.go('/auth/login');
                    },
                    child: const Text('Skip', style: TextStyle(fontSize: 18)),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: WormEffect(
                      spacing: 15,
                      dotColor: Colors.blueGrey.shade300,
                      activeDotColor: AppColor.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}
