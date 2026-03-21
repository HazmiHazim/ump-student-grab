import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/widget/custom_bottom_navigation_bar.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _navAnimController;

  final List<String> _appBarTitles = [
    'Home',
    'Bookings',
    'Chat',
    'My Account',
  ];

  @override
  void initState() {
    super.initState();
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    if (!_navAnimController.isAnimating) {
      _navAnimController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AppBar(
            title: Text(_appBarTitles[currentIndex]),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: widget.navigationShell,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedScreen: currentIndex,
        onDestinationSelected: _onTabSelected,
        navAnimation: _navAnimController,
      ),
    );
  }
}
