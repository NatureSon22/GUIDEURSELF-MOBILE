import 'package:flutter/material.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:guideurself/models/university_management.dart';
import 'package:guideurself/services/university_management_service.dart';

class CampusDetailsScreen extends StatefulWidget {
  final Campus campus;

  const CampusDetailsScreen({super.key, required this.campus});

  @override
  State<CampusDetailsScreen> createState() => _CampusDetailsScreenState();
}

class _CampusDetailsScreenState extends State<CampusDetailsScreen> {
  late Future<UniversityManagement> _universityFuture;

  @override
  void initState() {
    super.initState();
    // Fetch university details when the screen is initialized
    _universityFuture = _fetchUniversityDetails();
  }

  Future<UniversityManagement> _fetchUniversityDetails() async {
    final university = await fetchUniversityDetails();
    return university;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background with Opacity
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

          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // University Details (Logo and Vector)
                  FutureBuilder<UniversityManagement>(
                    future: _universityFuture,
                    builder: (context, universitySnapshot) {
                      if (!universitySnapshot.hasData) {
                        return const Center(child: Text(""));
                      }

                      final university = universitySnapshot.data!;
                      return Column(
                        children: [
                          // Header Section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // University Vector Image
                                if (university.universityVectorUrl != null &&
                                    university.universityVectorUrl!.isNotEmpty)
                                  Image.network(
                                    university.universityVectorUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          "Failed to load vector image: ${university.universityVectorUrl}");
                                      return const Icon(
                                          Icons.image_not_supported);
                                    },
                                  ),
                                const SizedBox(width: 4),
                                // University Logo
                                if (university.universityLogoUrl != null &&
                                    university.universityLogoUrl!.isNotEmpty)
                                  Image.network(
                                    university.universityLogoUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          "Failed to load logo image: ${university.universityLogoUrl}");
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
                          const SizedBox(height: 20),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            height: 20.0,
                            indent: 100.0,
                            endIndent: 100.0,
                          ),
                        ],
                      );
                    },
                  ),

                  // Campus Name
                  Text(
                    "${widget.campus.campusName.toUpperCase()} CAMPUS",
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: "CinzelDecorative",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Contact Information
                  _infoRow(Icons.phone, widget.campus.campusPhoneNumber),
                  _infoRow(Icons.email, widget.campus.campusEmail),
                  _infoRow(Icons.location_on, widget.campus.campusAddress),
                  const SizedBox(height: 20),

                  // About Section in a Container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 350),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "ABOUT",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.campus.campusAbout,
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Academic Programs Section in a Container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 350),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "ACADEMIC PROGRAMS",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        ...widget.campus.campusPrograms.map((program) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Program Names and Majors
                                  ...program.programs.map(
                                    (p) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Program Name
                                        Text(
                                          p.programName.trim(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),

                                        // Majors (if available)
                                        if (p.majors.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Major in:",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              ...p.majors.map(
                                                (major) => Text(
                                                  major.trim(),
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for contact info rows
  Widget _infoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
      children: [
        const SizedBox(width: 8), // Add spacing between the icon and text
        Flexible(
          child: RichText(
            textAlign: TextAlign.center, // Center the text
            text: TextSpan(
              children: [
                WidgetSpan(
                  child:
                      Icon(icon, size: 16), // Add the icon as part of the text
                ),
                const WidgetSpan(
                  child: SizedBox(
                      width: 8), // Add spacing between the icon and text
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black, // Set text color
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
