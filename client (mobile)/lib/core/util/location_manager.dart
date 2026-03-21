import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  LocationManager._internal();
  static LocationManager get shared => _instance;

  Position? currentPosition;
  StreamSubscription<Position>? _positionStream;

  void init() {
    _startTracking();
  }

  void _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 15,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) {
      currentPosition = position;
      FBroadcast.instance().broadcast('update_location', value: position);
      _savePosition(position);
      debugPrint('Location: ${position.latitude}, ${position.longitude}');
    });
  }

  void stop() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _savePosition(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.latitude);
    await prefs.setDouble('longitude', position.longitude);
  }

  static double calculateBearing(LatLng from, LatLng to) {
    final startLat = _toRad(from.latitude);
    final startLng = _toRad(from.longitude);
    final endLat = _toRad(to.latitude);
    final endLng = _toRad(to.longitude);
    final dLng = endLng - startLng;
    final y = math.sin(dLng) * math.cos(endLat);
    final x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(dLng);
    return (_toDeg(math.atan2(y, x)) + 360) % 360;
  }

  static double _toRad(double deg) => deg * (math.pi / 180);
  static double _toDeg(double rad) => rad * (180 / math.pi);
}
