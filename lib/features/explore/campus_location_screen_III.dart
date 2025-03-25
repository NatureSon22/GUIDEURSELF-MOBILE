import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/campus_model.dart' as campus_model; // Add alias
import '../../services/campus_service.dart';
import 'package:go_router/go_router.dart';

class CampusLocationScreenIII extends StatefulWidget {
  const CampusLocationScreenIII({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CampusLocationScreenIIIState createState() => _CampusLocationScreenIIIState();
}

class _CampusLocationScreenIIIState extends State<CampusLocationScreenIII> {
  final CampusService _campusService = CampusService();
  late Future<List<campus_model.Campus>> _campusFuture;

  @override
  void initState() {
    super.initState();
    _campusFuture = _campusService.fetchAllCampuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<campus_model.Campus>>(
        future: _campusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No campuses found"));
          }

          final campuses = snapshot.data!; // Get campuses data

          return Stack(
            children: [
              // Flutter Map
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(14.538244343986495, 121.1891562551365),
                  initialZoom: 12.5,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: campuses.map((campus_model.Campus campus) {
                      return Marker(
                        width: 50.0,
                        height: 50.0,
                        point: LatLng(
                          double.parse(campus.latitude),
                          double.parse(campus.longitude),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to CampusDetailsScreen with the selected campus
                            context.go("/campus-details", extra: campus);
                          },
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // ✅ Back Button Positioned on Top
              Positioned(
                top: 30, // Adjust as needed
                left: 3, // Adjust for padding
                child: IconButton(
                  onPressed: () {
                    context.go("/");
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp,
                      color: Colors.black),
                ),
              ),

              // ✅ Bottom Sheet
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomSheet(campuses),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet(List<campus_model.Campus> campuses) {
    TextEditingController searchController = TextEditingController();
    List<campus_model.Campus> filteredCampuses = List.from(campuses)
      ..sort((a, b) =>
          a.campusName.compareTo(b.campusName)); // Sort alphabetically

    return StatefulBuilder(
      builder: (context, setState) {
        void filterCampuses(String query) {
          setState(() {
            filteredCampuses = campuses
                .where((campus) => campus.campusName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList()
              ..sort((a, b) => a.campusName.compareTo(b.campusName)); // Re-sort
          });
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.12, // Start at 10% of screen
          minChildSize: 0.12, // Minimum height
          maxChildSize: 0.27, // Expand to 25% of screen
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // Drag Indicator
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Search bar and Icon Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          // Expanded makes the TextField take up remaining space
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged:
                                  filterCampuses, // Call the filter function
                              decoration: InputDecoration(
                                hintText: "Find Campus",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          searchController.clear();
                                          filterCampuses('');
                                        },
                                      )
                                    : const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Add some spacing
                          // Icon Button
                          IconButton(
                            icon: const Icon(
                                Icons.location_pin), // Use any icon you want
                            onPressed: () {
                              context.go("/virtual-tour");
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Horizontal List of Campuses
                    SizedBox(
                      height: 120,
                      child: filteredCampuses.isEmpty
                          ? const Center(child: Text("No campuses found"))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: filteredCampuses.length,
                              itemBuilder: (context, index) {
                                final campus = filteredCampuses[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          campus.campusCoverPhotoUrl,
                                          width: 150,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  bottom: Radius.circular(10)),
                                        ),
                                        child: Text(
                                          campus.campusName,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}