import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:guideurself/services/campus_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guideurself/features/explore/campus_details_screen.dart';
import 'package:guideurself/features/explore/floor_drawer.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';
import 'package:guideurself/features/explore/floor_list_drawer.dart';

class PanoramaViewScreen extends StatefulWidget {
  final Campus campus;

  const PanoramaViewScreen({super.key, required this.campus});

  @override
  State<PanoramaViewScreen> createState() => _PanoramaViewScreenState();
}

class _PanoramaViewScreenState extends State<PanoramaViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UniversityManagement> futureUniversityDetails;
  final CampusService _campusService = CampusService();

  List<Campus> _campuses = [];
  Campus? _selectedCampus;
  String? _selectedMarkerPhotoUrl;
  bool _isLoading = true;
  bool _isMarkerSelected = false;
  String? selectedFloorName = "Unknown Floor";
  String? _selectedFloor;

  List<Floor> floors = [];

  // Method to find the marker associated with the currently displayed photo URL
  Marker? _getMarkerByPhotoUrl(String? markerPhotoUrl) {
    if (_selectedCampus == null || markerPhotoUrl == null) return null;

    for (var floor in _selectedCampus!.floors) {
      for (var marker in floor.markers) {
        if (marker.markerPhotoUrl == markerPhotoUrl) {
          return marker;
        }
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    futureUniversityDetails = fetchUniversityDetails();
    _fetchCampuses();
    if (widget.campus.floors.isNotEmpty) {
      _selectedFloor = widget.campus.floors.first.floorName;
    }
  }

  void _onMarkerSelected(String markerPhotoUrl) {
    setState(() {
      _isMarkerSelected = true;
      _selectedMarkerPhotoUrl = markerPhotoUrl;
    });
  }

  void _onClose() {
    setState(() {
      _isMarkerSelected = false;
    });
  }

  void _onFloorSelected(String floorName) {
    setState(() {
      _selectedFloor = floorName;
      selectedFloorName = floorName; // Keep both variables in sync

      final selectedFloor = _selectedCampus!.floors.firstWhere(
        (f) => f.floorName == floorName,
        orElse: () => _selectedCampus!.floors.first,
      );

      if (selectedFloor.markers.isNotEmpty) {
        final marker = selectedFloor.markers.firstWhere(
          (m) => m.markerPhotoUrl.isNotEmpty,
          orElse: () => Marker(
            id: 'default-id',
            markerName: 'Unknown Marker',
            latitude: 0.0,
            longitude: 0.0,
            markerDescription: 'No description available',
            category: 'Others',
            markerPhotoUrl: '',
            dateAdded: DateTime.now(),
          ),
        );
        _selectedMarkerPhotoUrl = marker.markerPhotoUrl;
      } else {
        _selectedMarkerPhotoUrl = null;
      }
    });
  }

  Future<void> _fetchCampuses() async {
    try {
      List<Campus> campuses = await _campusService.fetchAllCampuses();

      // Filter only campuses with markers that have a photo
      campuses = campuses.where((campus) => campus.floors.isNotEmpty).toList();

      campuses.sort((a, b) => a.campusName.compareTo(b.campusName));

      Campus initialCampus = campuses.firstWhere(
        (c) => c.id == widget.campus.id,
        orElse: () => campuses.isNotEmpty
            ? campuses.first
            : Campus(
                id: '', // Provide valid default values
                campusName: 'Unknown',
                campusCode: '',
                campusPhoneNumber: '',
                campusEmail: '',
                campusAddress: '',
                campusCoverPhotoUrl: '',
                campusAbout: '',
                latitude: "",
                longitude: "",
                dateAdded: DateTime.now(),
                campusPrograms: [],
                floors: [],
              ),
      );

      String? initialPhotoUrl;

      for (var floor in initialCampus.floors) {
        for (var marker in floor.markers) {
          if (marker.markerPhotoUrl.isNotEmpty) {
            initialPhotoUrl = marker.markerPhotoUrl;
            break;
          }
        }
        if (initialPhotoUrl != null) break;
      }

      setState(() {
        _campuses = campuses;
        _selectedCampus = initialCampus;
        _selectedMarkerPhotoUrl = initialPhotoUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      backgroundColor: WidgetStateProperty.all(
        Colors.white.withOpacity(0.3),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      elevation: WidgetStateProperty.all(0),
      visualDensity: VisualDensity.comfortable,
    );
  }

  Widget _buildButtonContent({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String? currentMarkerPhotoUrl = _selectedMarkerPhotoUrl ?? "";
    String currentFloorName = "No Photo Available";
    List<Marker> currentFloorMarkers = [];
    final currentMarker = _getMarkerByPhotoUrl(currentMarkerPhotoUrl);
    bool hasMarkerPhoto = currentMarkerPhotoUrl.trim().isNotEmpty;

    if (_selectedCampus != null && hasMarkerPhoto) {
      for (var floor in _selectedCampus!.floors) {
        for (var marker in floor.markers) {
          if (marker.markerPhotoUrl == currentMarkerPhotoUrl) {
            selectedFloorName = floor.floorName;
            currentFloorMarkers = floor.markers;
            break;
          }
        }
        if (selectedFloorName != "No Photo Available") break; // Stop if found
      }
    }

    if (_selectedCampus != null) {
      for (var floor in _selectedCampus!.floors) {
        for (var marker in floor.markers) {
          if (marker.markerPhotoUrl == currentMarkerPhotoUrl) {
            currentFloorName = floor.floorName;
            currentFloorMarkers = floor.markers;
            break;
          }
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MenuDrawer(
        floorName: currentFloorName,
        markers: currentFloorMarkers,
        onClose: () => Navigator.of(context).pop(),
        onMarkerSelected: _onMarkerSelected, // Passing the function
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _isMarkerSelected && hasMarkerPhoto
                ? PanoramaViewer(
                    latitude: 0,
                    longitude: 0,
                    zoom: 1.0,
                    minLatitude: 0.0,
                    maxLatitude: 0.0,
                    minLongitude: -180.0,
                    maxLongitude: 180.0,
                    child: Image.network(
                      currentMarkerPhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            "Image failed to load",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
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
                                  fontFamily: "Cinzel",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const Text(
                              "Nurturing Tomorrow's Noblest",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "CinzelDecorative",
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                              child: Container(
                                width: 150, // Set fixed width
                                height: 40, // Set fixed height
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                      255, 18, 165, 188), // ✅ Background color
                                  borderRadius: BorderRadius.circular(
                                      7), // ✅ Rounded corners
                                ),
                                child: const Center(
                                  child: Text(
                                    "SELECT LOCATION",
                                    style: TextStyle(
                                        color: Colors.white, // ✅ Text color
                                        fontSize: 12,
                                        fontWeight: FontWeight
                                            .bold // Adjust font size if needed
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),

          // Floating Top Bar (Unchanged)
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back Button
                Container(
                  padding: const EdgeInsets.all(4), // Reduce padding
                  constraints: const BoxConstraints(
                    maxWidth: 40, // Minimum width
                    maxHeight: 40, // Minimum height
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        25), // Adjusted to fit smaller size
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.black,
                      size: 16, // Reduce icon size
                    ),
                    padding: EdgeInsets
                        .zero, // Remove extra padding inside IconButton
                    constraints:
                        const BoxConstraints(), // Allow the button to shrink
                  ),
                ),

                const SizedBox(width: 10),

                // Dropdown for Campus Selection (Unchanged)
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 40, // Minimum height
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.only(left: 17, right: 18),
                        child: DropdownButton<Campus>(
                          value: _selectedCampus,
                          onChanged: (Campus? newValue) {
                            if (newValue != null) {
                              String? newPhotoUrl;

                              for (var floor in newValue.floors) {
                                for (var marker in floor.markers) {
                                  if (marker.markerPhotoUrl.isNotEmpty) {
                                    newPhotoUrl = marker.markerPhotoUrl;
                                    break;
                                  }
                                }
                                if (newPhotoUrl != null) break;
                              }

                              setState(() {
                                _selectedCampus = newValue;
                                _selectedMarkerPhotoUrl = newPhotoUrl;
                                _isMarkerSelected = false;
                                _selectedFloor = _selectedFloor;
                              });
                            }
                          },
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black),
                          style: const TextStyle(color: Colors.black),
                          underline: const SizedBox(),
                          items: _campuses
                              .map<DropdownMenuItem<Campus>>((Campus campus) {
                            return DropdownMenuItem<Campus>(
                              value: campus,
                              child: Text(
                                campus.campusName,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Alert Icon
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 40, // Minimum width
                    maxHeight: 40, // Minimum height
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_selectedCampus != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CampusDetailsScreen(campus: _selectedCampus!),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.exclamation,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Menu Icon Button
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 40, // Minimum width
                    maxHeight: 40, // Minimum height
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 90,
            left: 16,
            child: SizedBox(
              height: 32,
              child: _isMarkerSelected && hasMarkerPhoto
                  ? ElevatedButton(
                      style: _buttonStyle(),
                      onPressed: () {},
                      child: _buildButtonContent(
                        icon: Icons.near_me,
                        text: currentMarker?.markerName ?? "Unknown",
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          Positioned(
            bottom: 20,
            right: 6,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedCampus != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FloorListDrawer(
                      floors: _selectedCampus!.floors,
                      selectedFloor: _selectedFloor,
                      onFloorSelected: _onFloorSelected,
                      onMarkerSelected: _onMarkerSelected,
                      onClose: _onClose,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child:
                  const Icon(Icons.location_on, color: Colors.black, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
