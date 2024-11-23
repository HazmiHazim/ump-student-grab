import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(0, -1),
          )
        ]
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) => states.contains(WidgetState.selected)
                      ? IconThemeData(color: Color.fromRGBO(26, 71, 143, 100))
                      : IconThemeData(color: Colors.black)
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (Set<WidgetState> states) => states.contains(WidgetState.selected)
                    ? const TextStyle(color: Color.fromRGBO(0, 159, 160, 100))
                    : const TextStyle(color: Colors.black),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: Color.fromRGBO(0, 159, 160, 100),
          selectedIndex: selectedScreen,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car),
              label: "Bookings",
              selectedIcon: Icon(Icons.directions_car),
            ),
            NavigationDestination(
              icon: (unreadMessages ?? 0) > 0 ? Badge(
                label: Text(unreadMessages.toString()),
                child: Icon(Icons.chat),
              ) : Icon(Icons.chat),
              label: "Chat",
              selectedIcon: (unreadMessages ?? 0) > 0 ? Badge(
                label: Text(unreadMessages.toString()),
                child: Icon(Icons.chat),
              ) : Icon(Icons.chat),
            ),
            NavigationDestination(
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