import 'package:flutter/material.dart';
import '../../services/key_official_service.dart'; // Import the university management service
import '../../models/key_official.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart'; // Import the university management model
import 'package:go_router/go_router.dart';

class KeyOfficialsScreen extends StatefulWidget {
  const KeyOfficialsScreen({super.key});

  @override
  State<KeyOfficialsScreen> createState() => _KeyOfficialsScreenState();
}

class _KeyOfficialsScreenState extends State<KeyOfficialsScreen> {
  late Future<List<KeyOfficial>> _keyOfficialsFuture;
  late Future<UniversityManagement>
      _universityFuture; // Future for university details

  @override
  void initState() {
    super.initState();
    _keyOfficialsFuture = fetchKeyOfficials();
    _universityFuture = fetchUniversityDetails(); // Fetch university details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.push("/explore"),
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
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
          // FutureBuilder for fetching university details
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, universitySnapshot) {
              if (universitySnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (universitySnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error loading university details: ${universitySnapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (!universitySnapshot.hasData) {
                return const Center(
                  child: Text(
                    "No university details found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // University details are available, now fetch key officials
              return FutureBuilder<List<KeyOfficial>>(
                future: _keyOfficialsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Error: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No key officials found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  List<KeyOfficial> keyOfficials = snapshot.data!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Use Image.network for the vector URL from the database
                              if (universitySnapshot
                                      .data!.universityVectorUrl !=
                                  null)
                                Image.network(
                                  universitySnapshot.data!.universityVectorUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons
                                        .image_not_supported); // Fallback if image fails to load
                                  },
                                ),
                              const SizedBox(width: 4),
                              // Use Image.network for the logo URL from the database
                              if (universitySnapshot.data!.universityLogoUrl !=
                                  null)
                                Image.network(
                                  universitySnapshot.data!.universityLogoUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons
                                        .image_not_supported); // Fallback if image fails to load
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 20),

                        // Key Officials List
                        Column(
                          children: keyOfficials.map((official) {
                            // Splitting name to move last word (surname) to the next line
                            List<String> nameParts = official.name.split(" ");
                            String formattedName = nameParts.length > 1
                                ? "${nameParts.sublist(0, nameParts.length - 1).join(" ")}\n${nameParts.last}"
                                : official.name;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding: const EdgeInsets.all(16.0),
                              width: double.infinity, // Ensures full width
                              constraints: const BoxConstraints(
                                minHeight: 250,
                                maxWidth: 250,
                              ), // Uniform height
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.3), // Opacity added
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235),
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Official Photo
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      official.keyOfficialPhotoUrl,
                                      width: 150, // Fixed width
                                      height: 150, // Fixed height
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.person,
                                                  size: 100,
                                                  color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),

                                  // Official Name
                                  Text(
                                    formattedName,
                                    textAlign: TextAlign.center,
                                    softWrap: true, // Ensures wrapping
                                    style: const TextStyle(
                              fontFamily: "Cinzel",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),

                                  // Official Position
                                  Text(
                                    official.positionName,
                                    textAlign: TextAlign.center,
                                    softWrap: true, // Ensures wrapping
                                    style: const TextStyle(
                              fontFamily: "CinzelDecorative",
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
