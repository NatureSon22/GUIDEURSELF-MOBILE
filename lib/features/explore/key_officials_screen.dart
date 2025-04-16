import 'package:flutter/material.dart';
import '../../services/key_official_service.dart'; // Import the university management service
import '../../models/key_official.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart'; // Import the university management model
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/campus_service.dart';
import 'package:guideurself/models/campus_model.dart';

class KeyOfficialsScreen extends StatefulWidget {
  const KeyOfficialsScreen({super.key});

  @override
  State<KeyOfficialsScreen> createState() => _KeyOfficialsScreenState();
}

class _KeyOfficialsScreenState extends State<KeyOfficialsScreen> {
  final CampusService _campusService = CampusService();
  List<Campus> _campuses = [];
  String? selectedCampusName;
  bool _isLoading = true;
  String _error = '';
  late Future<List<KeyOfficial>> _keyOfficialsFuture;
  late Future<UniversityManagement>
      _universityFuture; // Future for university details

  @override
  void initState() {
    super.initState();
    _fetchCampuses();
    _keyOfficialsFuture = fetchKeyOfficials();
    _universityFuture = fetchUniversityDetails(); // Fetch university details
  }

  Future<void> _fetchCampuses() async {
    try {
      List<Campus> campuses = await _campusService.fetchAllCampuses();
      campuses.sort((a, b) => a.campusName.compareTo(b.campusName));
      setState(() {
        _campuses = campuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load campuses";
        _isLoading = false;
      });
    }
  }

  Widget buildKeyOfficialCard(KeyOfficial official) {
    List<String> nameParts = official.name.split(" ");
    String formattedName = nameParts.length > 1
        ? "${nameParts.sublist(0, nameParts.length - 1).join(" ")}\n${nameParts.last}"
        : official.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 250, maxWidth: 250),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Color.fromARGB(255, 235, 235, 235), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              official.keyOfficialPhotoUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            formattedName,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontFamily: "Cinzel",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            official.positionName +
                (official.collegeName != null &&
                        official.collegeName!.isNotEmpty
                    ? " - ${official.collegeName!}"
                    : ''),
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontFamily: "CinzelDecorative",
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.go("/explore"),
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

          // FutureBuilder for fetching university details
          FutureBuilder<UniversityManagement>(
            future: _universityFuture,
            builder: (context, universitySnapshot) {
              if (universitySnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: const Color(0xFF12A5BC),
                  backgroundColor: const Color(0xFF323232).withOpacity(0.1),
                ));
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

              return FutureBuilder<List<KeyOfficial>>(
                future: _keyOfficialsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: const Color(0xFF12A5BC),
                      backgroundColor: const Color(0xFF323232).withOpacity(0.1),
                    ));
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

                  List<KeyOfficial> universityWide = keyOfficials
                      .where((official) =>
                          official.campusName == null ||
                          official.campusName!.isEmpty)
                      .toList();

                  List<KeyOfficial> campusBased = keyOfficials
                      .where((official) =>
                          official.campusName != null &&
                          official.campusName!.isNotEmpty)
                      .toList();

                  // Group by campusName
                  Map<String, List<KeyOfficial>> groupedByCampus = {};
                  for (var official in campusBased) {
                    String campus = official.campusName!;
                    groupedByCampus.putIfAbsent(campus, () => []).add(official);
                  }

                  // Optional: sort the map alphabetically by campus name
                  final sortedCampusEntries = groupedByCampus.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key));

                  // Grouped by campus section
                  final List<String> campusNames =
                      sortedCampusEntries.map((e) => e.key).toList();

                  // Initialize selected campus once
                  if (selectedCampusName == null && campusNames.isNotEmpty) {
                    selectedCampusName = campusNames.first;
                  }

                  final filteredCampusOfficials = selectedCampusName != null
                      ? groupedByCampus[selectedCampusName] ?? []
                      : [];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                         vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const Text(
                          "KEY OFFICIALS",
                          style: TextStyle(
                            fontFamily: "CinzelDecorative",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // University-wide section
                        if (universityWide.isNotEmpty) ...[
                          const Text("",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...universityWide.map<Widget>(
                              (official) => buildKeyOfficialCard(official)),
                          const SizedBox(height: 16),
                        ],

                        // Campus-based grouped section
                        // Campus Filter Buttons
                        if (campusNames.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: campusNames.map((campus) {
                                final isSelected = campus == selectedCampusName;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5, left:5),
                                  child: Container(
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF12A5BC),
                                                Color(0xFF0E46A3),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color:
                                          isSelected ? null : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(
                                          100.0), // Rounded container
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedCampusName = campus;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .transparent, // transparent background
                                        shadowColor:
                                            Colors.transparent, // no shadow
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        minimumSize: const Size(
                                            0, 30), // small button height
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              100.0), // rounded button shape
                                        ),
                                      ),
                                      child: Text(
                                        campus,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 161, 161, 161),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Filtered Campus Officials List
                          RichText(
                            text: TextSpan(
                              children: [
                                // First letter (Cinzel)
                                TextSpan(
                                  text: selectedCampusName!.isNotEmpty
                                      ? selectedCampusName![0]
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cinzel",
                                  ),
                                ),
                                // Rest of the text (CinzelDecorative)
                                TextSpan(
                                  text: selectedCampusName!.isNotEmpty
                                      ? "${selectedCampusName!.substring(1)} CAMPUS"
                                      : ' CAMPUS',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "CinzelDecorative",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ...filteredCampusOfficials.map<Widget>(
                              (official) => buildKeyOfficialCard(official))
                        ]
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
