import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDraggableBottomSheet extends StatelessWidget {
  final DraggableScrollableController draggableController;
  final Radius borderRadiusTopLeft;
  final Radius borderRadiusTopRight;
  final bool enableBookButton;

  const CustomDraggableBottomSheet({
    super.key,
    required this.draggableController,
    this.borderRadiusTopLeft = const Radius.circular(25.0),
    this.borderRadiusTopRight = const Radius.circular(25.0),
    required this.enableBookButton, // Parent controls this value
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                    const ListTile(title: Text('Jane Doe')),
                    const ListTile(title: Text('Jack Reacher')),
                  ],
                ),
              ),
              // Fixed ElevatedButton at the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: enableBookButton
                        ? const Color.fromRGBO(0, 159, 160, 100)
                        : Colors.grey.shade400, // Dimmed when disabled
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  onPressed: enableBookButton ? () => _onButtonPressed(context) : null, // Disable when false
                  child: const Text(
                    "Book",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onButtonPressed(BuildContext context) {
    // Handle button press action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Button Pressed")),
    );
  }
}
