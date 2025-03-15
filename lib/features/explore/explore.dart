import 'package:flutter/material.dart';
import 'package:guideurself/widgets/textgradient.dart';
import 'menu_drawer.dart';
import 'package:go_router/go_router.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<UniversityManagement> futureUniversityDetails;

  @override
  void initState() {
    super.initState();
    futureUniversityDetails =
        fetchUniversityDetails(); // Fetch images from backend
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sections = [
      {"title": "History", "route": "/history"},
      {"title": "Logo & Vector", "route": "/logo-vector"},
      {"title": "Vision, Mission & Core Values", "route": "/vision-mission"},
      {"title": "Key Officials", "route": "/key-officials"},
      {"title": "Campus Location", "route": "/campus-location"},
      {"title": "Virtual Campus Tour", "route": "/loading-screen"},
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
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: const MenuDrawer(),
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
                            onPressed: () {
                              // Navigate to the virtual tour screen
                              context.go("/loading-screen");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // Transparent background
                              shadowColor: Colors.transparent, // No shadow
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                    color: Color(0xFF12A5BC),
                                    width: 2), // Border color
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensure the row takes minimum space
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xFF12A5BC), // Icon color
                                  size: 16,
                                ),
                                SizedBox(
                                    width: 8), // Spacing between icon and text
                                GradientText(
                                  'Enter Virtual Tour',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF12A5BC),
                                      Color(0xFF0E46A3),
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
                        color: Color.fromARGB(255, 207, 207, 207),
                        thickness: 0.5,
                        height: 20.0,
                        indent: 100.0,
                        endIndent: 100.0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0),

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
                              context.go(section["route"]!);
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
                              section["title"]!,
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

                const SizedBox(height: 20.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFF12A5BC), width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 94, 139, 197)
                            .withOpacity(0.15),
                      ),
                      child: FutureBuilder<UniversityManagement>(
                        future: futureUniversityDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError ||
                              snapshot.data?.universityLogoUrl == null) {
                            return const Center(child: Text("Failed to load"));
                          }

                          final university = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    university.universityVectorUrl ?? '',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 10),
                                  Image.network(
                                    university.universityLogoUrl ?? '',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'University Of Rizal System',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const Text(
                                "Nurturing Tomorrow's Noblest",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ],
                          );
                        },
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
