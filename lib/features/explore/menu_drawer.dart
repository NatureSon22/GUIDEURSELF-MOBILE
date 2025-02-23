import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'logo_vector_screen.dart';
import 'vision_mission_screen.dart';
import 'key_officials_screen.dart';
import 'campus_location_screen.dart';
import 'virtual_tour_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.zero, // Remove any extra padding
            child: SizedBox(
              height: 110,
              child: Container(
                // Replace DrawerHeader with Container
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 206, 206, 206),
                        width: 1.0), // Optional bottom border
                  ),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'University of Rizal System',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Nurturing Tomorrow's Noblest",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center ListTiles
                children: [
                  _buildCenteredListTile("About", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen()),
                    );
                  }),
                  _buildCenteredListTile("Logo & Vector", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogoVectorScreen()),
                    );
                  }),
                  _buildCenteredListTile("Vision, Mission, and Core Values", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VisionMissionScreen()),
                    );
                  }),
                  _buildCenteredListTile("Key Officials", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const KeyOfficialsScreen()),
                    );
                  }),
                  _buildCenteredListTile("Campus Location", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CampusLocationScreen()),
                    );
                  }),
                  _buildCenteredListTile("Virtual Campus Tour", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VirtualTourScreen()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to create a centered ListTile
  Widget _buildCenteredListTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // Remove ListTile padding
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600, // Change font weight here
            fontSize: 12, // Adjust font size if needed
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
