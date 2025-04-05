import 'package:flutter/material.dart';
import 'package:guideurself/models/campus_model.dart';

class MenuDrawer extends StatelessWidget {
  final String floorName;
  final List<Marker> markers;
  final VoidCallback onClose;
  final VoidCallback onSet;
  final Function(String?) onMarkerSelected; // This is for marker selection
  final VoidCallback onSetFirstTime;

  const MenuDrawer({
    Key? key,
    required this.floorName,
    required this.markers,
    required this.onClose,
    required this.onSet,
    required this.onMarkerSelected,
    required this.onSetFirstTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter out markers with empty photo URLs
    final validMarkers =
        markers.where((marker) => marker.markerPhotoUrl.isNotEmpty).toList();
    final hasMarkers = validMarkers.isNotEmpty;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp edges
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10, top: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'University of Rizal System',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Nurturing Tomorrow's Noblest",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 207, 207, 207),
            thickness: 0.5,
            height: 5.0,
          ),

          // Floor Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: hasMarkers
                ? Text(
                    floorName,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 133, 133, 133),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null, // Returns null when hasMarkers is false
          ),

          // Marker List
          Expanded(
            child: hasMarkers
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: validMarkers.length,
                    itemBuilder: (context, index) {
                      final marker = validMarkers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2), // Reduce spacing
                        child: ListTile(
                          title: Text(
                            marker.markerName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            onSet();
                            onSetFirstTime(); // Call the function to set first time false
                            onMarkerSelected(marker
                                .markerPhotoUrl); // Handle marker selection
                            Navigator.of(context).pop(); // Close the drawer
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No markers available",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
