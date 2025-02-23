// explore.dart
import 'package:flutter/material.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'menu_drawer.dart'; // Import the drawer component

// Import your screens
import 'history_screen.dart';
import 'logo_vector_screen.dart';
import 'vision_mission_screen.dart';
import 'key_officials_screen.dart';
import 'campus_location_screen.dart';
import 'virtual_tour_screen.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    // List of buttons with corresponding screens
    final List<Map<String, dynamic>> sections = [
      {"title": "History", "screen": const HistoryScreen()},
      {"title": "Logo & Vector", "screen": const LogoVectorScreen()},
      {
        "title": "Vision, Mission & Core Values",
        "screen": const VisionMissionScreen()
      },
      {"title": "Key Officials", "screen": const KeyOfficialsScreen()},
      {"title": "Campus Location", "screen": const CampusLocationScreen()},
      {"title": "Virtual Campus Tour", "screen": const VirtualTourScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context)
                        .openEndDrawer(); // Open drawer on button tap
                  },
                );
              },
            ),
          ),
        ],
      ),
      endDrawer:
          const MenuDrawer(), // ✅ Ensure this is inside Scaffold, NOT in Stack!
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 0.3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/background-img.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.2, -1),
                ),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Intro Text & Button
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GradientText(
                        'Discover your\nuniversity like never',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                        gradient: LinearGradient(colors: [
                          Color(0xFF12A5BC),
                          Color(0xFF0E46A3),
                        ]),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const GradientText(
                            'before!',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(18, 165, 188, 1),
                              Color.fromRGBO(14, 70, 163, 1),
                            ]),
                          ),
                          const SizedBox(width: 14.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                    color: Color(0xFF12A5BC), width: 2),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensure the Row takes only the space it needs
                              children: [
                                Icon(
                                  Icons.arrow_forward, // Right arrow icon
                                  color: Color(0xFF12A5BC), // Arrow color
                                  size: 16, // Arrow size
                                ),
                                SizedBox(
                                    width:
                                        8), // Space between the arrow and text
                                GradientText(
                                  'Enter Virtual Tour',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF12A5BC),
                                      Color(0xFF0E46A3)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15.0),

                // Description + Divider
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigate, learn, and explore everything\nyour campus has to offer.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 15.0),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        height: 20.0,
                        indent: 100.0,
                        endIndent: 100.0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0),

                // Horizontally Scrollable Buttons for Navigation
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sections.map((section) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF12A5BC), Color(0xFF0E46A3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => section["screen"]),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: const Size(0, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                            child: Text(
                              section["title"],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20.0), // Add space before the container

                // Container just beneath the content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity, // Full width
                    height: 300, // Space inside the border
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      border: Border.all(
                        color: const Color(0xFF12A5BC), // Black border color
                        width: 2, // Border width
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 94, 139, 197)
                            .withOpacity(0.15), // Semi-transparent background
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/UrsVector.png', // Replace with your image path
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10), // Space between images
                              Image.asset(
                                'lib/assets/images/UrsLogo.png', // Replace with your image path
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height: 10), // Space between images and text
                          const Text(
                            'University Of Rizal System',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const Text(
                            "Nurturing Tomorrow's Noblest",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
