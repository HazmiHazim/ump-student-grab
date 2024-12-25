import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ump_student_grab_mobile/BL/location_service.dart';
import 'package:provider/provider.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/util/location_manager_util.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:ump_student_grab_mobile/widget/custom_draggable_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/map-screen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String query = "";
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the TextField
  List<String> _results = []; // List to hold search results
  bool isSearchCompleted = false; // Track whether the search is completed

  // For geolocation
  Set<Marker> markers = Set();
  late LatLng currentPosition;
  BitmapDescriptor? icon;

  final Completer<GoogleMapController> _gMapController = Completer<GoogleMapController>();
  final DraggableScrollableController draggableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    // Automatically request focus when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    // Load user from SharedPreferences using the utility method
    //User? user = await SharedPreferencesUtil.loadUser();
    var userId = "3";//user?.id;

    //getMarkerIcon();
    // Load the marker icon first, then add the marker
    getMarkerIcon().then((_) {
      addMarker();
    });

    currentPosition = LatLng(
        LocationManagerUtil.shared.currentPosition?.latitude ?? 0.0, LocationManagerUtil.shared.currentPosition?.longitude ?? 0.0
    );

    addMarker();

    FBroadcast.instance().register("update_location", (newLocation, callback) {
      if (newLocation is Position) {
        var markerId = MarkerId(userId.toString());
        var newPosition = LatLng(newLocation.latitude, newLocation.longitude);
        markers = {
          Marker(
            markerId:
            markerId,
            position:
            newPosition,
            icon: BitmapDescriptor.defaultMarker,
            rotation: LocationManagerUtil.calculateDegrees(currentPosition, newPosition),
            anchor: const Offset(0.5, 0.5)
          )
        };
        currentPosition = newPosition;
        setState(() {

        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode to avoid memory leaks
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      query = value;
      // You can replace this with actual search logic.
      _results = List.generate(10, (index) => "Result ${index + 1} for \"$query\"");
      isSearchCompleted = false;
    });
  }

  // Handle selection of a search result
  void _onSearchResultSelected(String result) {
    setState(() {
      query = result;
      isSearchCompleted = true; // Mark search as completed
    });
  }

  // Google Map
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<void> _goToMe() async {
    final GoogleMapController controller = await _gMapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition)
    ));
  }

  void addMarker() async {
    // Load user from SharedPreferences using the utility method
    User? user = await SharedPreferencesUtil.loadUser();
    var userId = user?.id;

    var markerId = MarkerId(userId.toString());

    setState(() {
      markers.add(Marker(markerId: markerId, position: currentPosition, icon: icon ?? BitmapDescriptor.defaultMarker  ));
    });
  }

  Future<void> getMarkerIcon() async {
    var loadedIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 3.2),
      "assets/images/car-marker.png",
      width: 30,
      height: 40,
    );

    setState(() {
      icon = loadedIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0, // Adjust the height to fit the design
        automaticallyImplyLeading: false, // Disable default back arrow
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context), // Navigate back
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add left and right gaps
                    child: TextField(
                      focusNode: _searchFocusNode, // Assign the FocusNode
                      decoration: InputDecoration(
                        hintText: "Type to search...",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search), // Add the search icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none, // Remove border for cleaner look
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      onChanged: _onSearchChanged,
                      onSubmitted: (value) {
                        _onSearchResultSelected(value);
                      },
                    ),
                  ),
                )
              ],
            ),
            // Suggestion List
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _gMapController.complete(controller);
            },
            markers: markers,
          ),
          // Suggestions list that overlaps the map
          if (!isSearchCompleted && query.isNotEmpty && _results.isNotEmpty)
            Positioned(
              top: 10.0, // Position below the search bar
              left: 16.0,
              right: 16.0,
              child: Container(
                height: 200.0, // Limit the height for the suggestions list
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black26)],
                ),
                child: ListView.builder(
                  itemCount: _results.take(5).length, // Show up to 5 results
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_results[index]),
                      onTap: () => _onSearchResultSelected(_results[index]),
                    );
                  },
                ),
              ),
            ),
          Positioned(
            top: 16.0, // Center vertically
            right: 4.0, // Place near the right edge
            child: FloatingActionButton(
              onPressed: _goToMe,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location), // Change to a pin-like icon
            ),
          ),
          CustomDraggableBottomSheet(draggableController: draggableController, enableBookButton: true),
        ],
      ),
    );
  }
}