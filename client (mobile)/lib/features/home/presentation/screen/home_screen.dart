import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user?.isDriver == true) return const _DriverHomeScreen();
    return const _PassengerHomeScreen();
  }
}

class _PassengerHomeScreen extends StatelessWidget {
  const _PassengerHomeScreen();

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

class _DriverHomeScreen extends StatefulWidget {
  const _DriverHomeScreen();

  @override
  State<_DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<_DriverHomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isOnline
                  ? AppColor.primary
                  : const Color.fromARGB(255, 200, 200, 200),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: () => setState(() => _isOnline = !_isOnline),
              child: Center(
                child: Text(
                  _isOnline ? 'ONLINE' : 'OFFLINE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isOnline
                ? 'You are online. Waiting for ride requests...'
                : 'Tap to go online and start accepting rides.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 100, 100, 100),
            ),
          ),
        ],
      ),
    );
  }
}
