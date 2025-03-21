import 'package:flutter/material.dart';
import 'package:guideurself/models/campus_model.dart';

class MenuDrawer extends StatelessWidget {
  final String floorName;
  final List<Marker> markers;
  final VoidCallback onClose;
  final Function(String) onMarkerSelected;

  MenuDrawer({
    Key? key,
    required this.floorName,
    required this.markers,
    required this.onClose,
    required this.onMarkerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp edges
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Padding(
            padding: EdgeInsets.only(
                right: 24.0, left: 10.0, top: 24.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'University of Rizal System',
                      style: TextStyle(
                        fontFamily: "Cinzel",
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Nurturing Tomorrow's Noblest",
                      style: TextStyle(
                        fontFamily: "CinzelDecorative",
                        color: Colors.black,
                        fontSize: 10,
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
            height: 5.0, // Reduce height further to move list up
          ),

          // Floor Name
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8), // Adjust padding
            child: Text(
              floorName,
              style: const TextStyle(
                color: Color.fromARGB(255, 133, 133, 133),
                fontSize: 10, // Slightly increase for better visibility
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Marker List - FIXED STRUCTURE
          Expanded(
            child: markers
                    .where((marker) => marker.markerPhotoUrl.isNotEmpty)
                    .isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: markers
                        .where((marker) => marker.markerPhotoUrl.isNotEmpty)
                        .length,
                    itemBuilder: (context, index) {
                      final filteredMarkers = markers
                          .where((marker) => marker.markerPhotoUrl.isNotEmpty)
                          .toList();
                      final marker = filteredMarkers[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
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
                            onMarkerSelected(marker.markerPhotoUrl);
                            Navigator.of(context).pop();
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
