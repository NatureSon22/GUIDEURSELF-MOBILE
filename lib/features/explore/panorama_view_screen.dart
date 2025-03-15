import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:guideurself/services/campus_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guideurself/features/explore/campus_details_screen.dart';
import 'package:guideurself/features/explore/floor_drawer.dart';
import 'package:guideurself/features/explore/category.dart';
import 'package:guideurself/features/explore/category_info_modal.dart';
import 'package:guideurself/features/explore/marker_details_drawer.dart';
import 'package:guideurself/features/explore/floor_list_drawer.dart';

class PanoramaViewScreen extends StatefulWidget {
  final Campus campus;

  const PanoramaViewScreen({super.key, required this.campus});

  @override
  State<PanoramaViewScreen> createState() => _PanoramaViewScreenState();
}

class _PanoramaViewScreenState extends State<PanoramaViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CampusService _campusService = CampusService();

  List<Campus> _campuses = [];
  Campus? _selectedCampus;
  String? _selectedMarkerPhotoUrl;
  bool _isLoading = true;
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
    _fetchCampuses();
    if (widget.campus.floors.isNotEmpty) {
      _selectedFloor = widget.campus.floors.first.floorName;
    }
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
      campuses = campuses
          .where((campus) => campus.floors.any((floor) =>
              floor.markers.any((marker) => marker.markerPhotoUrl.isNotEmpty)))
          .toList();

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
    String currentFloorName = "Unknown Floor";
    List<Marker> currentFloorMarkers = [];
    final currentMarker = _getMarkerByPhotoUrl(_selectedMarkerPhotoUrl);

    if (_selectedCampus != null && _selectedMarkerPhotoUrl != null) {
      for (var floor in _selectedCampus!.floors) {
        for (var marker in floor.markers) {
          if (marker.markerPhotoUrl == _selectedMarkerPhotoUrl) {
            selectedFloorName = floor.floorName;
            break;
          }
        }
        if (selectedFloorName != "Unknown Floor") break; // Stop if found
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
        onMarkerSelected: (markerPhotoUrl) {
          setState(() {
            _selectedMarkerPhotoUrl = markerPhotoUrl;
          });
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: currentMarkerPhotoUrl.isNotEmpty
                ? PanoramaViewer(
                    latitude: 0,
                    longitude: 0,
                    zoom: 1.0,
                    minLatitude: 0.0,
                    maxLatitude: 0.0,
                    minLongitude: -180.0,
                    maxLongitude: 180.0,
                    child:
                        Image.network(currentMarkerPhotoUrl, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Text("No 360° image available",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } // Navigate back to explore
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),

                // Dropdown for Campus Selection (Unchanged)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.only(left: 17, right: 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(50),
                        ),
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
                              });
                            }
                          },
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(50),
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
                    icon: const Icon(FontAwesomeIcons.exclamation,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),

                // Menu Icon Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Updated Positioned widgets based on the current marker
          Positioned(
            top: 100,
            left: 16,
            child: SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CategoryInfoModal(
                      icon:
                          getCategoryIcon(currentMarker?.category ?? "Others"),
                      category: currentMarker?.category ?? "Unknown",
                      iconColor:
                          getCategoryColor(currentMarker?.category ?? "Others"),
                      description: getCategoryDescription(
                          currentMarker?.category ?? "Others"),
                    ),
                  );
                },
                style: _buttonStyle(),
                child: _buildButtonContent(
                  icon: getCategoryIcon(currentMarker?.category ?? "Others"),
                  text: currentMarker?.category ?? "Unknown",
                ),
              ),
            ),
          ),

          Positioned(
            top: 140,
            left: 16,
            child: SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => MarkerDetailsDrawer(
                      markerName: currentMarker?.markerName ?? "Unknown",
                      category: currentMarker?.category ?? "Others",
                      markerDescription: currentMarker?.markerDescription ??
                          "No description available.",
                      markerPhotoUrl: currentMarker?.markerPhotoUrl ?? "",
                    ),
                  );
                },
                style: _buttonStyle(),
                child: _buildButtonContent(
                  icon: Icons.near_me,
                  text: currentMarker?.markerName ?? "Unknown",
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            right: 15,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedCampus != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FloorListDrawer(
                      floors: _selectedCampus!.floors,
                      selectedFloor: _selectedFloor, // SANA OKAY PAKO :>
                      onFloorSelected: _onFloorSelected,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
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
