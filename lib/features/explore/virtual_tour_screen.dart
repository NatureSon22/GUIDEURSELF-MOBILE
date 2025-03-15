import 'package:flutter/material.dart';
import 'package:guideurself/services/campus_service.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/university_management_service.dart'; 
import 'package:guideurself/models/university_management.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guideurself/features/explore/panorama_view_screen.dart';

class VirtualTourScreen extends StatefulWidget {
  const VirtualTourScreen({super.key});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  final CampusService _campusService = CampusService();
  List<Campus> _campuses = [];
  bool _isLoading = true;
  String _error = '';
  late Future<UniversityManagement>
      _universityFuture;

  @override
  void initState() {
    super.initState();
    _fetchCampuses();
    _universityFuture = fetchUniversityDetails();
  }

  Future<void> _fetchCampuses() async {
    try {
      List<Campus> campuses = await _campusService.fetchAllCampuses();
      campuses.sort((a, b) =>
          a.campusName.compareTo(b.campusName)); 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true, 
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 212, 212, 212), 
            width: 0.5, 
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.go("/explore");
          },
          icon: const Icon(FontAwesomeIcons.doorOpen,
              color: Color.fromARGB(255, 248, 105, 95), size: 17),
        ),
        title: const Text(
          'List of Campus',
          style: TextStyle(
            fontSize: 17, 
            fontWeight: FontWeight.w600,
          ),
        ), 
        actions: [
          IconButton(
            onPressed: () {
              context.go("/campus-location-II");
            },
            icon: const Icon(FontAwesomeIcons.map, size: 17),
          ),
        ],
      ),
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
                  ? Center(child: Text(_error))
                  : FutureBuilder<UniversityManagement>(
                      future: _universityFuture,
                      builder: (context, universitySnapshot) {
                        if (universitySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (universitySnapshot.hasError) {
                          return Center(
                            child: Text("Error: ${universitySnapshot.error}"),
                          );
                        } else if (!universitySnapshot.hasData) {
                          return const Center(
                              child: Text("No university details found."));
                        }

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
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
                                        return const Icon(Icons
                                            .image_not_supported); 
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
                                        return const Icon(Icons
                                            .image_not_supported); 
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const Text(
                              'University Of Rizal System',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const Text(
                              "Nurturing Tomorrow's Noblest",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            const SizedBox(height: 20),

                            ..._campuses.map((campus) {
                              bool hasValidMarkerPhoto = campus.floors.any(
                                  (floor) => floor.markers.any((marker) =>
                                      marker.markerPhotoUrl.isNotEmpty));

                              return ListTile(
                                title: Text(
                                  campus.campusName
                                      .toUpperCase(), 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: hasValidMarkerPhoto
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PanoramaViewScreen(
                                                      campus: campus),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hasValidMarkerPhoto
                                        ? Colors.blue
                                        : Colors.grey,
                                    foregroundColor:
                                        Colors.white, 
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            13), 
                                    minimumSize: const Size(100, 30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, 
                                    children: [
                                      Text(
                                        hasValidMarkerPhoto
                                            ? "See Campus"
                                            : "Not Available",
                                        style: const TextStyle(
                                            fontSize: 11), 
                                      ),
                                      if (hasValidMarkerPhoto)
                                        const SizedBox(
                                            width:
                                                2), 
                                      if (hasValidMarkerPhoto)
                                        const Icon(Icons.chevron_right,
                                            size: 14,
                                            color: Colors
                                                .white), 
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
