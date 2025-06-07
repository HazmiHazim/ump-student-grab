import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter_google_maps_webservices/places.dart";

class CustomDraggableBottomSheet extends StatelessWidget {
  final DraggableScrollableController draggableController;
  final Radius borderRadiusTopLeft;
  final Radius borderRadiusTopRight;
  final bool enableBookButton;
  final List<PlacesSearchResult> searchResults;
  final void Function(String, double?, double?) onPlaceSelected;

  const CustomDraggableBottomSheet({
    super.key,
    required this.draggableController,
    this.borderRadiusTopLeft = const Radius.circular(25.0),
    this.borderRadiusTopRight = const Radius.circular(25.0),
    required this.enableBookButton, // Parent controls this value
    required this.searchResults,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,  // Start at 40% of screen height
      minChildSize: 0.2,      // Minimum when dragged down
      maxChildSize: 0.65,      // Maximum when dragged up
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: borderRadiusTopLeft,
              topRight: borderRadiusTopRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 10.0, // Replace with actual value
                        width: 40.0, // Replace with actual value
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    ...searchResults.map((place) => Material(
                      color: Colors.transparent, // Use to keep the background clean
                      child: InkWell(
                        onTap: () => onPlaceSelected(place.placeId, place.geometry?.location.lat, place.geometry?.location.lng),
                        child: ListTile(
                          title: Text(place.name ?? "Unknown"),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
