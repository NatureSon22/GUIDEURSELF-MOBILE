import 'dart:async'; // Import the async library for Timer
import 'package:flutter/material.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<UniversityManagement> _universityFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _universityFuture = fetchUniversityDetails();

    // Start a timer for 5 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      // Navigate to another component after 5 seconds
      context.go('/virtual-tour'); // Replace with your desired route
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data found"));
              } else {
                final university = snapshot.data!;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (university.universityVectorUrl != null)
                                  Image.network(
                                    university.universityVectorUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.image_not_supported);
                                    },
                                  ),
                                const SizedBox(width: 4),
                                if (university.universityLogoUrl != null)
                                  Image.network(
                                    university.universityLogoUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.image_not_supported);
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const Text(
                            'University Of Rizal System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Cinzel",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          const Text(
                            "Nurturing Tomorrow's Noblest",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "CinzelDecorative",
                                fontSize: 12,
                                color: Colors.black),
                          ),
                          Image.asset(
                            'lib/assets/lottie/loading.gif', // Path to your GIF file
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (frame == null) {
                                return const CircularProgressIndicator(); // Show a loader while the GIF is loading
                              }
                              return child;
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                  Icons.error); // Fallback in case of an error
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
