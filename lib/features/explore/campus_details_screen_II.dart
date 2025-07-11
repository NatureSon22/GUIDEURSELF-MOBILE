// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
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
        elevation: 0,
        scrolledUnderElevation: 0,
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
                                      if (kDebugMode) {
                                        print(
                                            "Failed to load vector image: ${university.universityVectorUrl}");
                                      }
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
                                      if (kDebugMode) {
                                        print(
                                            "Failed to load logo image: ${university.universityLogoUrl}");
                                      }
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
                                fontSize: 16,),
                          ),
                          const Text(
                            "Nurturing Tomorrow's Noblest",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "CinzelDecorative",
                                fontSize: 12,),
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
                  const SizedBox(height: 5),

                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    widget.campus.campusCoverPhotoUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text('Failed to load image'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(85, 121, 233, 250),
                      shadowColor: Colors.transparent,
                      foregroundColor: const Color.fromARGB(255, 18, 165, 188),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "View Photo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 18, 165, 188),
                      ),
                    ),
                  ),

                  // About Section in a Container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 350),
                    decoration: BoxDecoration(
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
                              fontFamily: "CinzelDecorative",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "ACADEMIC PROGRAMS",
                            style: TextStyle(
                              fontFamily: "CinzelDecorative",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Loop through each program type
                        ...widget.campus.campusPrograms.map((programSchema) =>
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Program Type Title (e.g., Undergraduate, Graduate)
                                  Text(
                                    "${programSchema.programTypeId.trim()} Programs",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Loop through each program under this type
                                  ...programSchema.programs.map((program) =>
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Program Name (e.g., BSIT, BSIS)
                                            Text(
                                              program.programName.trim(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            // Majors (if any)
                                            if (program.majors.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12, top: 2),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Major in:",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    ...program.majors
                                                        .map((major) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8),
                                                              child: Text(
                                                                major.trim(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            11),
                                                              ),
                                                            )),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      )),
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
                    fontSize: 13, // Set text color
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
