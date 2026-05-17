import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedScreen;
  final ValueChanged<int> onDestinationSelected;
  final AnimationController navAnimation;
  final int? unreadMessages;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedScreen,
    required this.onDestinationSelected,
    required this.navAnimation,
    this.unreadMessages
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: const Offset(0, -1),
          )
        ]
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) => states.contains(WidgetState.selected)
                      ? const IconThemeData(color: Colors.white)
                      : const IconThemeData(color: Colors.black)
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? AppColor.primary
                  : AppColor.black,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: AppColor.primary,
          selectedIndex: selectedScreen,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
              selectedIcon: Icon(Icons.home),
            ),
            const NavigationDestination(
              icon: Icon(Icons.directions_car),
              label: "Bookings",
              selectedIcon: Icon(Icons.directions_car),
            ),
            NavigationDestination(
              icon: (unreadMessages ?? 0) > 0 ? Badge(
                label: Text(unreadMessages.toString()),
                child: const Icon(Icons.chat),
              ) : const Icon(Icons.chat),
              label: "Chat",
              selectedIcon: (unreadMessages ?? 0) > 0 ? Badge(
                label: Text(unreadMessages.toString()),
                child: const Icon(Icons.chat),
              ) : const Icon(Icons.chat),
            ),
            const NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: "My Account",
              selectedIcon: Icon(Icons.account_circle),
            )
          ],
        ),
      ),
    );
  }
}
