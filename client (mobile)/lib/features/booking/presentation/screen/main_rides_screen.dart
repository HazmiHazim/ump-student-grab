import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/screen/main_booking_screen.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/screen/driver_rides_screen.dart';

class MainRidesScreen extends ConsumerWidget {
  const MainRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user?.isDriver == true) return const DriverRidesScreen();
    return const MainBookingScreen();
  }
}
