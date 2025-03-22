import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:guideurself/models/campus_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guideurself/features/explore/category.dart';
import 'package:guideurself/features/explore/glowing_marker.dart';

class FloorListDrawer extends StatefulWidget {
  final List<Floor> floors;
  final String? selectedFloor;
  final Function(String) onFloorSelected;

  const FloorListDrawer({
    super.key,
    required this.floors,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FloorListDrawerState createState() => _FloorListDrawerState();
}

class _FloorListDrawerState extends State<FloorListDrawer> {
  String? _localSelectedFloor;
  String? _floorPhotoUrl;
  bool _isExpanded = false;
  List<flutter_map.Marker> _currentMarkers = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isGridLayout = false;
  late DraggableScrollableController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = DraggableScrollableController();
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
            child: Stack(
              children: [
                // Main Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Icon and Marker Name
                      Row(
                        children: [
                          // Container for Dynamic Icon
                          Container(
                            width:
                                30, // Fixed width and height to make it square
                            height: 30,
                            decoration: BoxDecoration(
                              color: getCategoryColor(marker.category)
                                  .withOpacity(0.2),
                              shape: BoxShape.circle, // Circular shape
                            ),
                            child: Center(
                              child: Icon(
                                getCategoryIcon(marker.category),
                                color: getCategoryColor(marker.category),
                                size: 16, // Smaller icon size
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // Spacing between icon and text
                          // Container for Marker Name
                          Container(
                            height: 30, // Same height as icon container
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  85, 121, 233, 250), // Fixed background color
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensures the row only takes necessary space
                                children: [
                                  Icon(
                                    Icons.near_me,
                                    color: Color.fromARGB(255, 18, 165, 188),
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    marker.markerName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 18, 165, 188),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      // Marker Description
                      Text(
                        marker.markerDescription,
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                // Close Icon (Upper Right Corner)
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 16,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
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
    return floor.markers
        .where(
            (marker) => marker.markerDescription.isNotEmpty) // Filter markers
        .map((marker) {
      bool isHighlighted = _searchController.text.isNotEmpty &&
          marker.markerName == _searchController.text;

      return flutter_map.Marker(
        point: LatLng(marker.latitude, marker.longitude),
        width: 40,
        height: 40,
        child: GlowingMarker(
          isHighlighted: isHighlighted,
          onTap: () => _showMarkerDetails(marker),
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

  void _searchMarker() {
    setState(() {
      _currentMarkers = _getMarkersForFloor(widget.floors.firstWhere(
        (floor) => floor.floorName == _localSelectedFloor,
        orElse: () => Floor(
            id: '', floorName: '', floorPhotoUrl: '', markers: [], order: 0),
      ));
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _searchMarker();
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            _searchMarker();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
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
                        color: Colors.grey[200],
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
                                      options: const flutter_map.MapOptions(
                                        backgroundColor: Colors.white,
                                        initialCenter:
                                            LatLng(14.484750, 121.189000),
                                        initialZoom: 17,
                                        minZoom: 16,
                                        maxZoom: 19, // Match max zoom with web
                                        interactionOptions:
                                            flutter_map.InteractionOptions(
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
                          options: const flutter_map.MapOptions(
                            backgroundColor: Colors.white,
                            initialCenter: LatLng(14.484750, 121.189000),
                            initialZoom: 17,
                            minZoom: 16,
                            maxZoom: 19, // Match max zoom with web
                            interactionOptions: flutter_map.InteractionOptions(
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
