import 'dart:async'; // Import the async library for Timer
import 'package:flutter/material.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<UniversityManagement> _universityFuture;
  Timer? _timer;
  bool _isVisible = true; // Controls widget visibility

  @override
  void initState() {
    super.initState();
    _universityFuture = fetchUniversityDetails();

    // Start a timer for 6 seconds
    _timer = Timer(const Duration(seconds: 6), () {
      setState(() {
        _isVisible = false; // Hide the widget instead of navigation
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 1,
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

          // Use Visibility to hide content
          Visibility(
            visible: _isVisible,
            child: FutureBuilder<UniversityManagement>(
              future: _universityFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    
                  ));
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
                                        return const Icon(Icons.image_not_supported);
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
                                        return const Icon(Icons.image_not_supported);
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
                              "Virtual Campus Tour",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "CinzelDecorative",
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                            Image.asset(
                              'lib/assets/lottie/loading.gif',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                if (frame == null) {
                                  return  CircularProgressIndicator(
                                     color: const Color(0xFF12A5BC),
            backgroundColor: const Color(0xFF323232).withOpacity(0.1),
                                  );
                                }
                                return child;
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
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
          ),
        ],
      ),
    );
  }
}

