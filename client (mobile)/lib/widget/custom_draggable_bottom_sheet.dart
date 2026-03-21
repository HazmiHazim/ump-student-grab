import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';

class CustomDraggableBottomSheet extends StatelessWidget {
  final DraggableScrollableController draggableController;
  final Radius borderRadiusTopLeft;
  final Radius borderRadiusTopRight;
  final bool enableBookButton;
  final List<Place> searchResults;
  final void Function(String, double?, double?) onPlaceSelected;

  const CustomDraggableBottomSheet({
    super.key,
    required this.draggableController,
    this.borderRadiusTopLeft = const Radius.circular(25.0),
    this.borderRadiusTopRight = const Radius.circular(25.0),
    required this.enableBookButton,
    required this.searchResults,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.65,
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
                        height: 10.0,
                        width: 40.0,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    ...searchResults.map((place) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onPlaceSelected(place.placeId, place.lat, place.lng),
                            child: ListTile(
                              title: Text(place.name),
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
