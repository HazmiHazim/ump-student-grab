import 'dart:async';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:ump_student_grab_mobile/core/network/dio_client.dart';
import 'package:ump_student_grab_mobile/core/util/location_manager.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';

import 'package:ump_student_grab_mobile/features/booking/presentation/providers.dart';
import 'package:ump_student_grab_mobile/widget/custom_draggable_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _searchFocusNode = FocusNode();
  final _gMapController = Completer<gmaps.GoogleMapController>();
  final _draggableController = DraggableScrollableController();

  Set<gmaps.Marker> _markers = {};
  late gmaps.LatLng _currentPosition;
  late gmaps.CameraPosition _initialCameraPosition;
  Set<gmaps.Polyline> _polylines = {};
  gmaps.BitmapDescriptor? _markerIcon;
  String _markerDestinationId = '';

  String _query = '';
  List<String> _suggestionLabels = [];
  bool _isSearchCompleted = false;
  List<Place> _searchResults = [];

  Timer? _debounce;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
      _init();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _debounce?.cancel();
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  Future<void> _init() async {
    final userJson = await ref.read(localStorageProvider).getUser();
    _currentUserId = userJson?['id'] as int?;

    final lat = LocationManager.shared.currentPosition?.latitude ?? 0.0;
    final lng = LocationManager.shared.currentPosition?.longitude ?? 0.0;
    _currentPosition = gmaps.LatLng(lat, lng);
    _initialCameraPosition =
        gmaps.CameraPosition(target: _currentPosition, zoom: 16.8491);

    _markerIcon = await gmaps.BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 3.2),
      'assets/images/car-marker.png',
      width: 30,
      height: 40,
    );

    _addMarker(_currentUserId.toString(), _currentPosition);

    FBroadcast.instance().register('update_location', (newLocation, _) {
      if (newLocation is Position) {
        final newPos =
            gmaps.LatLng(newLocation.latitude, newLocation.longitude);
        final markerId = gmaps.MarkerId(_currentUserId.toString());
        setState(() {
          _markers = {
            gmaps.Marker(
              markerId: markerId,
              position: newPos,
              icon: gmaps.BitmapDescriptor.defaultMarker,
              rotation: LocationManager.calculateBearing(
                  _currentPosition, newPos),
              anchor: const Offset(0.5, 0.5),
            )
          };
          _currentPosition = newPos;
        });
      }
    }, context: this);
  }

  void _addMarker(String id, gmaps.LatLng position) {
    setState(() {
      _markers.removeWhere(
          (m) => m.markerId == gmaps.MarkerId(_markerDestinationId));
      _markers.add(gmaps.Marker(
        markerId: gmaps.MarkerId(id),
        position: position,
        icon: _markerIcon ?? gmaps.BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<void> _goToMe() async {
    final controller = await _gMapController.future;
    controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
      gmaps.CameraPosition(target: _currentPosition, zoom: 16.8491),
    ));
  }

  Future<void> _moveCameraTo(gmaps.LatLng position) async {
    final controller = await _gMapController.future;
    controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
      gmaps.CameraPosition(target: position, zoom: 15),
    ));
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        setState(() {
          _suggestionLabels = [];
          _isSearchCompleted = false;
        });
        return;
      }
      final repo = ref.read(bookingRepositoryProvider);
      final result = await repo.autocomplete(value);
      result.fold(
        (_) {},
        (suggestions) => setState(() {
          _query = value;
          _suggestionLabels =
              suggestions.map((s) => s.description).toList();
          _isSearchCompleted = false;
        }),
      );
    });
  }

  Future<void> _onSearchSubmitted(String query) async {
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.searchByText(query);
    result.fold(
      (_) {},
      (places) => setState(() {
        _searchResults = places;
        _query = query;
        _isSearchCompleted = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Type to search...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          gmaps.GoogleMap(
            mapType: gmaps.MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (c) => _gMapController.complete(c),
            markers: _markers,
            polylines: _polylines,
          ),
          if (!_isSearchCompleted &&
              _query.isNotEmpty &&
              _suggestionLabels.isNotEmpty)
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Colors.black26)
                  ],
                ),
                child: ListView.builder(
                  itemCount: _suggestionLabels.take(5).length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(_suggestionLabels[i]),
                    onTap: () => _onSearchSubmitted(_suggestionLabels[i]),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 4,
            child: FloatingActionButton(
              onPressed: _goToMe,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location),
            ),
          ),
          CustomDraggableBottomSheet(
            draggableController: _draggableController,
            enableBookButton: true,
            searchResults: _searchResults,
            onPlaceSelected: (destinationId, lat, lng) async {
              final origin =
                  '${_currentPosition.latitude},${_currentPosition.longitude}';
              final destination = 'place_id:$destinationId';
              final destLatLng = gmaps.LatLng(lat ?? 3.1529, lng ?? 101.7039);

              final repo = ref.read(bookingRepositoryProvider);
              final result =
                  await repo.getDirections(origin, destination);

              result.fold(
                (_) {},
                (encodedPolyline) {
                  if (encodedPolyline == null || encodedPolyline.isEmpty) return;
                  final points =
                      PolylinePoints().decodePolyline(encodedPolyline);
                  final coords = points
                      .map((p) => gmaps.LatLng(p.latitude, p.longitude))
                      .toList();

                  setState(() {
                    _polylines
                      ..clear()
                      ..add(gmaps.Polyline(
                        polylineId: const gmaps.PolylineId('route'),
                        points: coords,
                        color: Colors.blue,
                        width: 5,
                      ));
                    _addMarker(destinationId, destLatLng);
                    _markerDestinationId = destinationId;
                  });
                  _moveCameraTo(destLatLng);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
