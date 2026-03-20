import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ump_student_grab_mobile/BL/places_service.dart';
import 'package:ump_student_grab_mobile/Model/place_result.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/util/location_manager_util.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:ump_student_grab_mobile/widget/custom_draggable_bottom_sheet.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/map-screen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String query = "";
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _recommendedSearchList = [];
  bool isSearchCompleted = false;
  List<PlaceResult> _searchResult = [];

  // For geolocation
  Set<gmaps.Marker> markers = Set();
  late gmaps.LatLng currentPosition;
  gmaps.BitmapDescriptor? icon;

  final Completer<gmaps.GoogleMapController> _gMapController = Completer<gmaps.GoogleMapController>();
  final DraggableScrollableController draggableController = DraggableScrollableController();

  late gmaps.CameraPosition _initialCameraPosition;

  final PlacesService _placesService = PlacesService();

  Timer? _debounce;
  Set<gmaps.Polyline> _polylines = {};

  late String _markerDestinationId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
    _initializeGMap();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: "Type to search...",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchResultSubmitted,
                      onTap: () {
                        _searchFocusNode.unfocus();
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          gmaps.GoogleMap(
            mapType: gmaps.MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (gmaps.GoogleMapController controller) {
              _gMapController.complete(controller);
            },
            markers: markers,
            polylines: _polylines,
          ),
          if (!isSearchCompleted && query.isNotEmpty && _recommendedSearchList.isNotEmpty)
            Positioned(
              top: 10.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                height: 250.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black26)],
                ),
                child: ListView.builder(
                  itemCount: _recommendedSearchList.take(5).length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recommendedSearchList[index]),
                      onTap: () => _onSearchResultSubmitted(_recommendedSearchList[index]),
                    );
                  },
                ),
              ),
            ),
          Positioned(
            top: 16.0,
            right: 4.0,
            child: FloatingActionButton(
              onPressed: _goToMe,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location),
            ),
          ),
          CustomDraggableBottomSheet(
            draggableController: draggableController,
            enableBookButton: true,
            searchResults: _searchResult,
            onPlaceSelected: (destinationId, latitude, longitude) async {
              final String origin = "${currentPosition.latitude},${currentPosition.longitude}";
              final String destination = "place_id:$destinationId";
              final gmaps.LatLng destinationLocation = gmaps.LatLng(latitude ?? 3.1529, longitude ?? 101.7039);

              final encodedPolyline = await _placesService.getDirections(origin, destination);

              if (encodedPolyline != null && encodedPolyline.isNotEmpty) {
                final decodedPoints = PolylinePoints().decodePolyline(encodedPolyline);
                final polylineCoordinates = decodedPoints
                    .map((p) => gmaps.LatLng(p.latitude, p.longitude))
                    .toList();

                setState(() {
                  _polylines
                    ..clear()
                    ..add(gmaps.Polyline(
                      polylineId: gmaps.PolylineId("route"),
                      points: polylineCoordinates,
                      color: Colors.blue,
                      width: 5,
                    ));
                  addMarker(destinationId, destinationLocation);
                  _markerDestinationId = destinationId;
                  moveCameraTo(destinationLocation);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        setState(() {
          _recommendedSearchList = [];
          isSearchCompleted = false;
        });
        return;
      }

      final suggestions = await _placesService.autocomplete(value);

      setState(() {
        query = value;
        _recommendedSearchList = suggestions.map((s) => s.description).toList();
        isSearchCompleted = false;
      });
    });
  }

  void _onSearchResultSubmitted(String result) async {
    final results = await _placesService.searchByText(result);

    setState(() {
      _searchResult = results;
      query = result;
      isSearchCompleted = true;
    });
  }

  Future<void> _goToMe() async {
    final gmaps.GoogleMapController controller = await _gMapController.future;
    await controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(target: currentPosition, zoom: 16.8491)));
  }

  void addMarker(String userId, gmaps.LatLng position) {
    var markerId = gmaps.MarkerId(userId);

    setState(() {
      markers.removeWhere((m) => m.markerId == gmaps.MarkerId(_markerDestinationId));
      markers.add(
        gmaps.Marker(
          markerId: markerId,
          position: position,
          icon: icon ?? gmaps.BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Future<void> getMarkerIcon() async {
    var loadedIcon = await gmaps.BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 3.2),
      "assets/images/car-marker.png",
      width: 30,
      height: 40,
    );

    setState(() {
      icon = loadedIcon;
    });
  }

  Future<void> _initializeGMap() async {
    User? user = await SharedPreferencesUtil.loadUser();
    var userId = user?.id;

    final lat = LocationManagerUtil.shared.currentPosition?.latitude ?? 0.0;
    final lng = LocationManagerUtil.shared.currentPosition?.longitude ?? 0.0;
    currentPosition = gmaps.LatLng(lat, lng);
    _initialCameraPosition = gmaps.CameraPosition(target: currentPosition, zoom: 16.8491);

    await getMarkerIcon();
    addMarker(userId.toString(), currentPosition);

    FBroadcast.instance().register("update_location", (newLocation, callback) {
      if (newLocation is Position) {
        var markerId = gmaps.MarkerId(userId.toString());
        var newPosition = gmaps.LatLng(newLocation.latitude, newLocation.longitude);
        markers = {
          gmaps.Marker(
            markerId: markerId,
            position: newPosition,
            icon: gmaps.BitmapDescriptor.defaultMarker,
            rotation: LocationManagerUtil.calculateDegrees(currentPosition, newPosition),
            anchor: const Offset(0.5, 0.5),
          )
        };
        currentPosition = newPosition;
        setState(() {});
      }
    });
  }

  Future<void> moveCameraTo(gmaps.LatLng position) async {
    final gmaps.GoogleMapController controller = await _gMapController.future;
    controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
      gmaps.CameraPosition(target: position, zoom: 15),
    ));
  }
}
