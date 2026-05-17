import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/notifier/map_notifier.dart';
import 'package:ump_student_grab_mobile/features/booking/repository/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.read(dioProvider));
});

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);
