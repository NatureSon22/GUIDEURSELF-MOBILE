import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:guideurself/features/explore/category.dart';
import 'package:guideurself/features/explore/glowing_marker.dart';

class FloorListDrawer extends StatefulWidget {
  final List<Floor> floors;
  final String? selectedFloor;
  final Function(String) onFloorSelected;
  final VoidCallback onClose;
  final Function(String) onMarkerSelected;

  const FloorListDrawer({
    super.key,
    required this.floors,
    required this.selectedFloor,
    required this.onFloorSelected,
    required this.onClose,
    required this.onMarkerSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FloorListDrawerState createState() => _FloorListDrawerState();
}

class _FloorListDrawerState extends State<FloorListDrawer> {
  final TextEditingController _searchController = TextEditingController();
  double? _markerLatitude;
  double? _markerLongitude;
  UniqueKey _mapKey = UniqueKey();
  String? _localSelectedFloor;
  String? _floorPhotoUrl;
  bool _isExpanded = false;
  List<flutter_map.Marker> _currentMarkers = [];
  bool _isGridLayout = false;

  @override
  void initState() {
    super.initState();
    _localSelectedFloor = widget.selectedFloor;
    _updateFloorPhoto(widget.selectedFloor);
  }

  void _showMarkerDetails(Marker marker) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 400, // Fixed width for the Dialog
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // Main Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Icon and Marker Name
                    Row(
                      children: [
                        // Container for Dynamic Icon
                        if (marker.category.isNotEmpty)
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: getCategoryColor(marker.category)
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                getCategoryIcon(marker.category),
                                color: getCategoryColor(marker.category),
                                size: 16,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8), // Spacing

                        // Container for Marker Name
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(85, 121, 233, 250),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.near_me,
                                  color: Color.fromARGB(255, 18, 165, 188),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  marker.markerName.length > 27
                                      ? '${marker.markerName.substring(0, 24)}...' // Truncate and add "..."
                                      : marker.markerName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 18, 165, 188),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: false, // Disable wrapping
                                  overflow: TextOverflow
                                      .ellipsis, // Ensure the text gets ellipsized
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Marker Description
                    Text(
                      marker.markerDescription,
                      style: const TextStyle(fontSize: 11),
                    ),

                    const SizedBox(height: 15), // Spacing

                    // Centered Button
                    if (marker.markerPhotoUrl.isNotEmpty)
                      Align(
                        alignment: Alignment.center, // ✅ Align to the right
                        child: SizedBox(
                          // ✅ Adjust width
                          height: 30, // ✅ Adjust height
                          child: GestureDetector(
                            onTap: () {
                              widget.onMarkerSelected(marker.markerPhotoUrl);
                              _toggleExpanded();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 18, 165, 188), // ✅ Background color
                                borderRadius: BorderRadius.circular(
                                    7), // ✅ Rounded corners
                              ),
                              child: const Center(
                                child: Text(
                                  "360° View",
                                  style: TextStyle(
                                    color: Colors.white, // ✅ Text color
                                    fontSize: 11, // Adjust font size if needed
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateFloorPhoto(String? floorName) {
    final selectedFloor = widget.floors.firstWhere(
      (floor) => floor.floorName == floorName,
      orElse: () => Floor(
          id: '', floorName: '', floorPhotoUrl: '', markers: [], order: 0),
    );
    setState(() {
      _floorPhotoUrl = selectedFloor.floorPhotoUrl;
      _currentMarkers = _getMarkersForFloor(selectedFloor);
    });
  }

  List<flutter_map.Marker> _getMarkersForFloor(Floor floor) {
    return floor.markers.map((marker) {
      bool isHighlighted = _searchController.text.isNotEmpty &&
          marker.markerName == _searchController.text;

      return flutter_map.Marker(
        point: LatLng(marker.latitude, marker.longitude),
        width: 40,
        height: 40,
        child: GlowingMarker(
          isHighlighted: isHighlighted,
          onTap: () => _showMarkerDetails(marker),
          category: marker.category, // Ensure this is not null or empty
        ),
      );
    }).toList();
  }

  final DraggableScrollableController _controller =
      DraggableScrollableController();

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.animateTo(
        0, // Use minChildSize and maxChildSize dynamically
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _controller.animateTo(
        1, // Use minChildSize and maxChildSize dynamically
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _searchMarker(String markerName) {
    setState(() {
      // Find the selected floor
      final selectedFloor = widget.floors.firstWhere(
        (floor) => floor.floorName == widget.selectedFloor,
        orElse: () => Floor(
          id: '',
          floorName: '',
          floorPhotoUrl: '',
          markers: [],
          order: 0,
        ),
      );

      // Find the marker by its name
      final marker = selectedFloor.markers.firstWhere(
        (marker) => marker.markerName == markerName,
        orElse: () => Marker(
          id: '',
          markerName: '',
          markerDescription: '',
          markerPhotoUrl: '',
          latitude: 14.484750, // Set to null if marker is not found
          longitude: 121.189000, // Set to null if marker is not found
          category: '',
          dateAdded: DateTime.now(),
        ),
      );

      // Update the state with the marker's coordinates
      _markerLatitude = marker.latitude;
      _markerLongitude = marker.longitude;

      // Force the map to rebuild by updating the key
      _mapKey = UniqueKey();

      // Show feedback if the marker is not found
      if (marker.latitude == 14.484750 || marker.longitude == 121.189000) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Location Not Found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "No such location found on this floor. Please try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  void _toggleGridLayout() {
    setState(() {
      _isGridLayout = !_isGridLayout;
    });
  }

  Widget _buildFloorButton(Floor floor, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _localSelectedFloor = floor.floorName;
          _updateFloorPhoto(floor.floorName);
        });

        widget.onFloorSelected(floor.floorName);

        if (floor.markers.any((m) => m.markerPhotoUrl.isNotEmpty)) {
          widget.onClose();
        } else {
          widget.onMarkerSelected("");
          widget.onClose();
        }
      },
      // Removed invalid 'style' parameter
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 18, 165, 188)
                : const Color.fromARGB(85, 121, 233, 250),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              floor.floorName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 18, 165, 188),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFloors = widget.floors;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 1,
      minChildSize: 0,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 253, 253),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                // Clear the text field
                                _searchController.clear();
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            // Call _searchMarker only if the search query is not empty
                            if (value.trim().isNotEmpty) {
                              _searchMarker(value.trim());
                            } else {
                              // Handle empty search (e.g., show a message or reset the map)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please enter a search term.')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _isGridLayout
                              ? const Color.fromARGB(255, 18, 165, 188)
                              : Colors.black,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.layers,
                          size: 20,
                          color: _isGridLayout
                              ? const Color.fromARGB(255, 18, 165, 188)
                              : Colors.black,
                        ),
                        onPressed: _toggleGridLayout,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_downward,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: _toggleExpanded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (!_isGridLayout)
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredFloors.length,
                      itemBuilder: (context, index) {
                        final floor = filteredFloors[index];
                        final bool isSelected =
                            floor.floorName == _localSelectedFloor;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildFloorButton(floor, isSelected),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 15),
                if (_isGridLayout)
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.8, // Adjust height as needed
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: filteredFloors.length,
                      itemBuilder: (context, index) {
                        final floor = filteredFloors[index];
                        final markers = _getMarkersForFloor(floor);
                        final bool isSelected =
                            floor.floorName == _localSelectedFloor;

                        return Column(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _localSelectedFloor = floor.floorName;
                                    _updateFloorPhoto(floor.floorName);
                                  });
                                  widget.onFloorSelected(floor.floorName);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: flutter_map.FlutterMap(
                                      key: _mapKey,
                                      options: flutter_map.MapOptions(
                                        backgroundColor: Colors.white,
                                        initialCenter: _markerLatitude !=
                                                    null &&
                                                _markerLongitude != null
                                            ? LatLng(_markerLatitude!,
                                                _markerLongitude!) // Use the marker's location
                                            : const LatLng(14.484750,
                                                121.189000), // Fallback to the default center
                                        initialZoom: 17,
                                        minZoom: 16,
                                        maxZoom: 19, // Match max zoom with web
                                        interactionOptions: const flutter_map
                                            .InteractionOptions(
                                          flags: flutter_map
                                                  .InteractiveFlag.pinchZoom |
                                              flutter_map.InteractiveFlag.drag |
                                              flutter_map.InteractiveFlag
                                                  .flingAnimation |
                                              flutter_map
                                                  .InteractiveFlag.pinchMove |
                                              flutter_map.InteractiveFlag
                                                  .doubleTapZoom,
                                        ),
                                      ),
                                      children: [
                                        flutter_map.OverlayImageLayer(
                                          overlayImages: [
                                            flutter_map.OverlayImage(
                                              bounds: flutter_map.LatLngBounds(
                                                const LatLng(
                                                    14.480740, 121.184750),
                                                const LatLng(14.488870,
                                                    121.192500), // Max Lat, Max Lng (Match with web)
                                              ),
                                              imageProvider: NetworkImage(
                                                  floor.floorPhotoUrl),
                                            ),
                                          ],
                                        ),
                                        flutter_map.MarkerLayer(
                                          markers: markers,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            _buildFloorButton(floor, isSelected),
                          ],
                        );
                      },
                    ),
                  )
                else if (_floorPhotoUrl != null && _floorPhotoUrl!.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.8, // Adjust height as needed
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: flutter_map.FlutterMap(
                          key: _mapKey,
                          options: flutter_map.MapOptions(
                            backgroundColor: Colors.white,
                            initialCenter: _markerLatitude != null &&
                                    _markerLongitude != null
                                ? LatLng(_markerLatitude!,
                                    _markerLongitude!) // Use the marker's location
                                : const LatLng(14.484750, 121.189000),
                            initialZoom: 17,
                            minZoom: 16,
                            maxZoom: 19, // Match max zoom with web
                            cameraConstraint:
                                flutter_map.CameraConstraint.contain(
                              bounds: flutter_map.LatLngBounds(
                                const LatLng(14.480740, 121.184750),
                                const LatLng(14.488870, 121.192500),
                              ),
                            ),
                            interactionOptions:
                                const flutter_map.InteractionOptions(
                              flags: flutter_map.InteractiveFlag.pinchZoom |
                                  flutter_map.InteractiveFlag.drag |
                                  flutter_map.InteractiveFlag.flingAnimation |
                                  flutter_map.InteractiveFlag.pinchMove |
                                  flutter_map.InteractiveFlag.doubleTapZoom,
                            ),
                          ),
                          children: [
                            flutter_map.OverlayImageLayer(
                              overlayImages: [
                                flutter_map.OverlayImage(
                                  bounds: flutter_map.LatLngBounds(
                                    const LatLng(14.480740, 121.184750),
                                    const LatLng(14.488870, 121.192500),
                                  ),
                                  imageProvider: NetworkImage(_floorPhotoUrl!),
                                ),
                              ],
                            ),
                            flutter_map.MarkerLayer(
                              markers: _currentMarkers,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
