import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/features/booking/data/datasource/places_remote_data_source.dart';
import 'package:ump_student_grab_mobile/features/booking/data/repository/booking_repository_impl.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/repository/booking_repository.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/notifier/map_notifier.dart';

final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>((ref) {
  return PlacesRemoteDataSourceImpl(ref.read(dioProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(ref.read(placesRemoteDataSourceProvider));
});

final mapNotifierProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);
