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
  Future<List<KeyOfficial>> _keyOfficialsFuture =
      Future.value([]); // Initialize with empty list
  Future<UniversityManagement> _universityFuture =
      Future.value(UniversityManagement()); // Initialize with empty object

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final campuses = await _campusService.fetchAllCampuses();
      final keyOfficials = await fetchKeyOfficials();
      final universityDetails = await fetchUniversityDetails();

      setState(() {
        _campuses = campuses;
        _keyOfficialsFuture = Future.value(keyOfficials);
        _universityFuture = Future.value(universityDetails);
        if (campuses.isNotEmpty) {
          // Sort campuses alphabetically by name
          campuses.sort((a, b) => a.campusName.compareTo(b.campusName));
          // Set to first campus in alphabetical order
          selectedCampusName = campuses.first.campusName;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  Future<List<Campus>> _fetchCampuses() async {
    final response = await CampusService().fetchAllCampuses();
    return response; // Ensure this is List<Campus>
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

              return Builder(
                builder: (context) {
                  final List<String> campusNames = _campuses
                      .map((campus) => campus.campusName)
                      .where((name) => name.isNotEmpty)
                      .toList()
                    ..sort();

                  return FutureBuilder<List<KeyOfficial>>(
                    future: _keyOfficialsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: const Color(0xFF12A5BC),
                          backgroundColor:
                              const Color(0xFF323232).withOpacity(0.1),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFF12A5BC),
                        ));
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

                      Map<String, List<KeyOfficial>> groupedByCampus = {};
                      for (var official in campusBased) {
                        String campus = official.campusName!;
                        groupedByCampus
                            .putIfAbsent(campus, () => [])
                            .add(official);
                      }

                      if (selectedCampusName == null &&
                          campusNames.isNotEmpty) {
                        selectedCampusName = campusNames.first;
                      }

                      final filteredCampusOfficials = selectedCampusName != null
                          ? groupedByCampus[selectedCampusName] ?? []
                          : [];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- header and logos ---
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (universitySnapshot
                                          .data!.universityVectorUrl !=
                                      null)
                                    Image.network(
                                      universitySnapshot
                                          .data!.universityVectorUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                            Icons.image_not_supported);
                                      },
                                    ),
                                  const SizedBox(width: 4),
                                  if (universitySnapshot
                                          .data!.universityLogoUrl !=
                                      null)
                                    Image.network(
                                      universitySnapshot
                                          .data!.universityLogoUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                            Icons.image_not_supported);
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
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Nurturing Tomorrow's Noblest",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "CinzelDecorative",
                                fontSize: 12,
                                color: Colors.black,
                              ),
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

                            // University-wide officials
                            if (universityWide.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ...universityWide.map<Widget>(
                                  (official) => buildKeyOfficialCard(official)),
                              const SizedBox(height: 16),
                            ],

                            // Campus Filter Buttons
                            if (campusNames.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: campusNames.map((campus) {
                                    final isSelected =
                                        campus == selectedCampusName;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5, left: 5),
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
                                          color: isSelected
                                              ? null
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedCampusName = campus;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            minimumSize: const Size(0, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
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
                              RichText(
                                text: TextSpan(
                                  children: [
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
                              if (filteredCampusOfficials.isNotEmpty)
                                ...filteredCampusOfficials.map<Widget>(
                                    (official) =>
                                        buildKeyOfficialCard(official)),
                              if (filteredCampusOfficials.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    "No Key Officials",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: "CinzelDecorative",
                                    ),
                                  ),
                                ),
                            ]
                          ],
                        ),
                      );
                    },
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
