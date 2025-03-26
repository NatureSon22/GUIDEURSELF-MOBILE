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
          Padding(
            padding: const EdgeInsets.only(
                right: 24.0, left: 10.0, top: 24.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onClose,
                ),
                const Column(
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
            // Ensure markers take remaining space
            child: markers.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero, // Remove extra space
                    itemCount: markers.length,
                    itemBuilder: (context, index) {
                      final marker = markers[index];
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
