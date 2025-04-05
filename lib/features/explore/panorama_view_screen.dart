import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:guideurself/services/campus_service.dart';
import 'package:guideurself/features/explore/campus_details_screen.dart';
import 'package:guideurself/features/explore/floor_drawer.dart';
import '../../services/university_management_service.dart';
import 'package:guideurself/features/explore/category.dart';
import 'package:guideurself/features/explore/category_info_modal.dart';
import 'package:guideurself/features/explore/location_info_modal.dart';
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
  bool isFirstTime = true;

  void setFirstTimeFalse() {
    setState(() {
      isFirstTime = false;
    });
  }

  List<Campus> _campuses = [];
  Campus? _selectedCampus;
  String? _selectedMarkerPhotoUrl;
  bool _isMarkerSelected = false;
  bool _isSetFloorSelected = false;
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
  }

  void _onMarkerSelected(String? markerPhotoUrl) {
    setState(() {
      if (markerPhotoUrl != null) {
        // Case when a valid marker is selected
        _isMarkerSelected = true;
        _selectedMarkerPhotoUrl = markerPhotoUrl;
      } else {
        // Case when no valid markers are available
        _isMarkerSelected = true;
        // Optionally reset the selected marker photo
        _selectedMarkerPhotoUrl = null;
        // Keep showing the current floor without changing
      }
    });
  }

  void _onClose() {
    setState(() {
      _isMarkerSelected = true;
    });
  }

  void _onSelectFloor() {
    setState(() {
      _isSetFloorSelected = true;
    });
  }

  void _onFloorSelected(String floorName) {
    setState(() {
      _selectedFloor = floorName;
      selectedFloorName = floorName;

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
            markerPhotoUrl: '', // Empty URL means no panorama will load
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

    // Select the first floor, regardless of whether it has a marker
    Floor firstFloor = initialCampus.floors.firstWhere(
      (floor) => floor.markers.isNotEmpty,
      orElse: () => initialCampus.floors.first,
    );

    // Get the first available marker photo URL (if any)
    String? initialPhotoUrl;
    for (var marker in firstFloor.markers) {
      if (marker.markerPhotoUrl.isNotEmpty) {
        initialPhotoUrl = marker.markerPhotoUrl;
        break;
      }
    }

    final firstFloorWithMarkers = initialCampus.floors.firstWhere(
      (floor) => floor.markers.isNotEmpty,
      orElse: () => initialCampus.floors.first,
    );

    setState(() {
      _campuses = campuses;
      _selectedCampus = initialCampus;
      _selectedMarkerPhotoUrl = initialPhotoUrl;
      _selectedFloor = firstFloorWithMarkers.floorName;
      selectedFloorName = firstFloorWithMarkers.floorName;
    });
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

    if (_selectedCampus != null && currentMarkerPhotoUrl.isNotEmpty) {
      bool found = false;

      for (var floor in _selectedCampus!.floors) {
        for (var marker in floor.markers) {
          if (marker.markerPhotoUrl == currentMarkerPhotoUrl) {
            selectedFloorName = floor.floorName;
            currentFloorName = floor.floorName; // Use consistent naming
            currentFloorMarkers = floor.markers;
            found = true;
            break;
          }
        }
        if (found) break;
      }

      if (!found) {
        selectedFloorName = "No Photo Available";
        currentFloorName = "No Photo Available";
        currentFloorMarkers = [];
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        endDrawer: MenuDrawer(
          floorName: currentFloorName,
          markers: currentFloorMarkers,
          onClose: () => Navigator.of(context).pop(),
          onMarkerSelected: _onMarkerSelected,
          onSetFirstTime: setFirstTimeFalse,
          onSet: _onSelectFloor,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),

            Positioned.fill(
              child: hasMarkerPhoto && _isMarkerSelected
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
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.15),
                      ),
                      child: FutureBuilder<UniversityManagement>(
                        future: futureUniversityDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: const Color(0xFF12A5BC),
                              backgroundColor:
                                  const Color(0xFF323232).withOpacity(0.1),
                            ));
                          } else if (snapshot.hasError ||
                              snapshot.data?.universityLogoUrl == null) {
                            return const Center(child: Text("Failed to load"));
                          }

                          final university = snapshot.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 280,
                                height: 250,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/webp/full_float.gif'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              isFirstTime
                                  ? const Column(
                                      children: [
                                        Text(
                                          "Hey there explorer! I'm\nGiga your campus\nguide!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "To kick things off, select a location to start our\nadventure!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Column(
                                      children: [
                                        Text(
                                          "Oops! It looks like this\nfloor doesn’t have any\npanorama to explore! ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "To keep exploring, choose another floor from the\nbottom drawer!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: 20),
                              isFirstTime
                                  ? GestureDetector(
                                      onTap: () {
                                        _scaffoldKey.currentState
                                            ?.openEndDrawer();
                                      },
                                      child: Container(
                                        width: 130, // Set fixed width
                                        height: 35, // Set fixed height
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(85, 121,
                                              233, 250), // ✅ Background color
                                          borderRadius: BorderRadius.circular(
                                              7), // ✅ Rounded corners
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Select Location",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 18,
                                                  165, 188), // ✅ Text color
                                              fontSize:
                                                  11, // Adjust font size if needed
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
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
                          size: 16,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),

                    // Campus Name Button (Expanding middle element)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (_selectedCampus != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CampusDetailsScreen(
                                        campus: _selectedCampus!),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Center(
                                child: Text(
                                  _selectedCampus?.campusName ?? 'Campus',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Menu Button
                    Container(
                      width: 40,
                      height: 40,
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
            ),

            if (currentMarker?.category != null &&
                currentMarker!.category.isNotEmpty)
              Positioned(
                top: 130,
                left: 16,
                child: SizedBox(
                  height: 35,
                  child: hasMarkerPhoto && _isMarkerSelected
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CategoryInfoModal(
                                icon: getCategoryIcon(currentMarker.category),
                                category: currentMarker.category,
                                iconColor:
                                    getCategoryColor(currentMarker.category),
                                description: getCategoryDescription(
                                    currentMarker.category),
                              ),
                            );
                          },
                          style: _buttonStyle(),
                          child: _buildButtonContent(
                            icon: getCategoryIcon(currentMarker.category),
                            text: currentMarker.category,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

            Positioned(
              top: 90,
              left: 16,
              child: SizedBox(
                height: 32,
                child: hasMarkerPhoto && _isMarkerSelected
                    ? ElevatedButton(
                        style: _buttonStyle(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => LocationInfoModal(
                              description: currentMarker!.markerDescription,
                            ),
                          );
                        },
                        child: _buildButtonContent(
                          icon: Icons.near_me,
                          text: currentMarker?.markerName ?? "Unknown",
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: _isSetFloorSelected ? Offset(0, 0) : Offset(0, 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _isSetFloorSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: _isSetFloorSelected
                      ? FloorListDrawer(
                          floors: _selectedCampus!.floors,
                          selectedFloor: _selectedFloor,
                          onFloorSelected: _onFloorSelected,
                          onMarkerSelected: _onMarkerSelected,
                          onClose: _onClose,
                          onSet: setFirstTimeFalse,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ));
  }
}
