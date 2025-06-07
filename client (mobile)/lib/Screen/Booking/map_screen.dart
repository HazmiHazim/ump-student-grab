import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ump_student_grab_mobile/Model/user.dart';
import 'package:ump_student_grab_mobile/util/location_manager_util.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';
import 'package:ump_student_grab_mobile/widget/custom_draggable_bottom_sheet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:flutter_google_maps_webservices/places.dart";
import "package:flutter_google_maps_webservices/directions.dart" as gmapswebservice;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  static const routeName = "/map-screen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String query = "";
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the TextField
  List<String> _recommendedSearchList = []; // List to hold search results
  bool isSearchCompleted = false; // Track whether the search is completed
  List<PlacesSearchResult> _searchResult = [];

  // For geolocation
  Set<gmaps.Marker> markers = Set();
  late gmaps.LatLng currentPosition;
  gmaps.BitmapDescriptor? icon;

  final Completer<gmaps.GoogleMapController> _gMapController = Completer<gmaps.GoogleMapController>();
  final DraggableScrollableController draggableController = DraggableScrollableController();

  late gmaps.CameraPosition _initialCameraPosition;

  late final String gMapApiKey;
  late final GoogleMapsPlaces gMapPlaces;
  late final gmapswebservice.GoogleMapsDirections gMapDirections;

  Timer? _debounce;
  Set<gmaps.Polyline> _polylines = {};

  late String _markerDestinationId = ""; // To save the destination id to remove old marker

  @override
  void initState() {
    super.initState();
    // Automatically request focus when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    _initializeGMap();
    gMapApiKey = dotenv.get("GOOGLE_MAP_API_KEY");
    gMapPlaces = GoogleMapsPlaces(apiKey: gMapApiKey);
    gMapDirections = gmapswebservice.GoogleMapsDirections(apiKey: gMapApiKey);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode to avoid memory leaks
    _debounce?.cancel();
    super.dispose();
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
                        _onSearchResultSubmitted(value);
                      },
                      onTap: () {
                        _searchFocusNode.unfocus(); // dismiss keyboard
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
          gmaps.GoogleMap(
            mapType: gmaps.MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (gmaps.GoogleMapController controller) {
              _gMapController.complete(controller);
            },
            markers: markers,
            polylines: _polylines,
          ),
          // Suggestions list that overlaps the map
          if (!isSearchCompleted && query.isNotEmpty && _recommendedSearchList.isNotEmpty)
            Positioned(
              top: 10.0, // Position below the search bar
              left: 16.0,
              right: 16.0,
              child: Container(
                height: 250.0, // Limit the height for the suggestions list
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black26)],
                ),
                child: ListView.builder(
                  itemCount: _recommendedSearchList.take(5).length, // Show up to 5 results
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
            top: 16.0, // Center vertically
            right: 4.0, // Place near the right edge
            child: FloatingActionButton(
              onPressed: _goToMe,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location), // Change to a pin-like icon
            ),
          ),
          CustomDraggableBottomSheet(
            draggableController: draggableController,
            enableBookButton: true,
            searchResults: _searchResult,
            onPlaceSelected: (destinationId, latitude, longitude) async {
              // Covert current position to string
              final String currentPositionStr = "${currentPosition.latitude},${currentPosition.longitude}";
              final gmaps.LatLng destinationLocation = gmaps.LatLng(latitude ?? 3.1529, longitude ?? 101.7039);

              final directionResp = await gMapDirections.directions(
                currentPositionStr, // Origin
                "place_id:$destinationId", // Destination
              );

              if (directionResp.isOkay && directionResp.routes.isNotEmpty) {
                final encodedPolyline = directionResp.routes[0].overviewPolyline.points;

                /// Decode to points using PolylinePoints
                PolylinePoints polylinePoints = PolylinePoints();
                List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPolyline);

                /// Convert to google_maps_flutter LatLng
                List<gmaps.LatLng> polylineCoordinates = decodedPoints
                    .map((p) => gmaps.LatLng(p.latitude, p.longitude))
                    .toList();

                setState(() {
                  _polylines.clear();
                  _polylines.clear();
                  _polylines.add(
                    gmaps.Polyline(
                      polylineId: gmaps.PolylineId("route"),
                      points: polylineCoordinates,
                      color: Colors.blue,
                      width: 5,
                    ),
                  );

                  addMarker(destinationId, destinationLocation);
                  _markerDestinationId = destinationId;
                  // Animate camera after marker is set
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

      PlacesAutocompleteResponse autoCompleteResp = await gMapPlaces.autocomplete(value, region: "MY");

      if (autoCompleteResp.isOkay && autoCompleteResp.predictions.isNotEmpty) {
        var predictions = autoCompleteResp.predictions;

        setState(() {
          query = value;
          _recommendedSearchList = predictions.map((p) => p.description ?? "").toList();
          isSearchCompleted = false;
        });
      } else {
        setState(() {
          _recommendedSearchList = List.generate(10, (index) => "Result ${index + 1} for \"$value\"");
          isSearchCompleted = false;
        });
      }
    });
  }

  // Handle selection of a search result
  void _onSearchResultSubmitted(String result) async {
    final placesSearchResp = await gMapPlaces.searchByText(result, region: "MY");

    if (placesSearchResp.isOkay && placesSearchResp.results.isNotEmpty) {
      final results = placesSearchResp.results;
      setState(() {
        _searchResult = results;
        query = result;
        isSearchCompleted = true;
      });
    }
  }

  Future<void> _goToMe() async {
    final gmaps.GoogleMapController controller = await _gMapController.future;
    await controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(target: currentPosition, zoom: 16.8491)
    ));
  }

  void addMarker(String userId, gmaps.LatLng position) {
    var markerId = gmaps.MarkerId(userId);

    setState(() {
      // Remove any previous destination markers (excluding current location marker)
      markers.removeWhere((m) => m.markerId == gmaps.MarkerId(_markerDestinationId));

      // Add the new destination marker
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
    // Load user
    User? user = await SharedPreferencesUtil.loadUser();
    var userId = user?.id;

    final lat = LocationManagerUtil.shared.currentPosition?.latitude ?? 0.0;
    final lng = LocationManagerUtil.shared.currentPosition?.longitude ?? 0.0;
    currentPosition = gmaps.LatLng(lat, lng);
    _initialCameraPosition = gmaps.CameraPosition(target: currentPosition, zoom: 16.8491);

    //getMarkerIcon();
    // Load the marker icon first, then add the marker
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
              anchor: const Offset(0.5, 0.5)
          )
        };
        currentPosition = newPosition;
        setState(() {

        });
      }
    });
  }

  // Function to move camera
  Future<void> moveCameraTo(gmaps.LatLng position) async {
    final gmaps.GoogleMapController controller = await _gMapController.future;
    controller.animateCamera(gmaps.CameraUpdate.newCameraPosition(
      gmaps.CameraPosition(target: position, zoom: 15),
    ));
  }
}