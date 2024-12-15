import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;

class LocationManagerUtil {
  static final LocationManagerUtil singleton = LocationManagerUtil._internal();

  // Private internal constructor
  LocationManagerUtil._internal();

  static LocationManagerUtil get shared => singleton;

  // For geolocation
  Position? currentPosition;
  StreamSubscription<Position>? _positionStream;

  void initLocation() {
    updateUserGeoLocation();
    //_simulateMovingLocation(); // Uncomment this for testing
  }

  void updateUserGeoLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location service are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        debugPrint("Location permission is denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission are permanently denied. Unable to request permission");
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 15 // Update location every 15 meters
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      currentPosition = position;
      FBroadcast.instance().broadcast("update_location", value: position);
      // Save the position in SharedPreferences
      SharedPreferencesUtil.saveLocation(position);  // Call the saveLocation method
      debugPrint(position.toString());
    });
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
    debugPrint("Location updates stopped.");
  }

  static double calculateDegrees(LatLng startPoint, LatLng endPoint) {
    final double startLatitude = toRadians(startPoint.latitude);
    final double startLongitude = toRadians(startPoint.longitude);
    final double endLatitude = toRadians(endPoint.latitude);
    final double endLongitude = toRadians(endPoint.longitude);

    final double deltaLongitude = endLongitude - startLongitude;

    final double y = Math.sin(deltaLongitude) * Math.cos(endLatitude);
    final double x = Math.cos(startLatitude) * Math.sin(endLatitude) -
        Math.sin(startLatitude) * Math.cos(endLatitude) * Math.cos(deltaLongitude);

    final double bearing = Math.atan2(y, x);

    return ( toDegrees(bearing) + 360 ) % 360;
  }

  static double toRadians(double degrees) {
    return degrees * (Math.pi / 180.0);
  }

  static double toDegrees(double radians) {
    return radians * (180.0 / Math.pi);
  }

  // ======================================================
  //          For Testing Moving Location
  // ======================================================
  // Simulated location variables
  double latitude = 3.1565;  // Starting latitude (e.g., KLCC)
  double longitude = 101.7045;  // Starting longitude (e.g., KLCC)
  void _simulateMovingLocation() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      // Simulate location change by adding small random offsets
      latitude += (Math.Random().nextDouble() - 0.5) * 0.03;  // Small random change
      longitude += (Math.Random().nextDouble() - 0.5) * 0.03; // Small random change

      // Create a new Position object with the updated latitude and longitude
      currentPosition = Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          headingAccuracy: 0.0
      );

      // Broadcast the updated location
      FBroadcast.instance().broadcast("update_location", value: currentPosition);

      // Optionally, save the simulated location
      SharedPreferencesUtil.saveLocation(currentPosition!);

      // Debug print to check the updated position
      debugPrint(currentPosition.toString());
    });
  }
}