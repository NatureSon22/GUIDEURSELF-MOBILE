import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import '../../models/campus_model.dart' as campus_model; // Add alias
import '../../services/campus_service.dart';
import 'package:go_router/go_router.dart';
import '../../services/university_management_service.dart';
import '../../models/university_management.dart';

class CampusLocationScreen extends StatefulWidget {
  const CampusLocationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CampusLocationScreenState createState() => _CampusLocationScreenState();
}

class _CampusLocationScreenState extends State<CampusLocationScreen> {
  final CampusService _campusService = CampusService();
  late Future<List<campus_model.Campus>> _campusFuture;
  final PopupController _popupController = PopupController();
  late Future<UniversityManagement> _universityFuture;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _universityFuture = fetchUniversityDetails();
    _campusFuture = _campusService.fetchAllCampuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UniversityManagement>(
      future: _universityFuture,
      builder: (context, universitySnapshot) {
        if (universitySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (universitySnapshot.hasError) {
          return Center(
              child: Text(
                  "Error loading university: ${universitySnapshot.error}"));
        } else if (!universitySnapshot.hasData) {
          return const Center(child: Text("University data not found"));
        }

        final university = universitySnapshot.data!;

        return FutureBuilder<List<campus_model.Campus>>(
          future: _campusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: const Color(0xFF12A5BC),
                backgroundColor: const Color(0xFF323232).withOpacity(0.1),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No campuses found"));
            }

            final campuses = snapshot.data!;

            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        const LatLng(14.538244343986495, 121.1891562551365),
                    initialZoom: 12.5,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    onTap: (_, __) => _popupController.hideAllPopups(),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PopupMarkerLayer(
                      options: PopupMarkerLayerOptions(
                        markers: campuses.map((campus_model.Campus campus) {
                          return Marker(
                            width: 50,
                            height: 50,
                            point: LatLng(
                              double.parse(campus.latitude),
                              double.parse(campus.longitude),
                            ),
                            child: const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Color.fromARGB(255, 69, 160, 245),
                            ),
                          );
                        }).toList(),
                        popupDisplayOptions: PopupDisplayOptions(
                          builder: (BuildContext context, Marker marker) {
                            final campus = campuses.firstWhere((c) =>
                                double.parse(c.latitude) ==
                                    marker.point.latitude &&
                                double.parse(c.longitude) ==
                                    marker.point.longitude);
                            return GestureDetector(
                              onTap: () {
                                context.push("/campus-details", extra: campus);
                              },
                              child: Card(
                                child: IntrinsicWidth(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 7,
                                        right: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              university.universityLogoUrl ??
                                                  "",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.school,
                                                      size: 40),
                                            ),
                                            const SizedBox(width: 2),
                                            Image.network(
                                              university.universityVectorUrl ??
                                                  "",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                      Icons.location_city,
                                                      size: 40),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${campus.campusName.toUpperCase()} CAMPUS",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          "CinzelDecorative",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.1,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                    child: Text(
                                                      "Nurturing Tomorrow's Noblest",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontFamily: "Poppins",
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        height: 1.1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 30,
                  left: 3,
                  child: IconButton(
                    onPressed: () {
                      context.go("/explore");
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomSheet(campuses),
                ),
              ],
            );
          },
        );
      },
    ));
  }

  Widget _buildBottomSheet(List<campus_model.Campus> campuses) {
    TextEditingController searchController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.10,
          minChildSize: 0.10,
          maxChildSize: 0.10,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5)
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Find Campus",
                              hintStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 2),
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                final campus = campuses.firstWhere(
                                  (campus) =>
                                      campus.campusName.toLowerCase() ==
                                      value.toLowerCase(),
                                  orElse: () => campus_model.Campus(
                                    campusName: '',
                                    latitude: '0',
                                    longitude: '0',
                                    id: '',
                                    campusCode: '',
                                    campusPhoneNumber: '',
                                    campusEmail: '',
                                    campusAddress: '',
                                    campusCoverPhotoUrl: '',
                                    campusAbout: '',
                                    campusPrograms: [],
                                    dateAdded: DateTime.now(),
                                    floors: [],
                                  ),
                                );
                                if (campus.campusName.isNotEmpty) {
                                  _mapController.move(
                                    LatLng(
                                      double.parse(campus.latitude),
                                      double.parse(campus.longitude),
                                    ),
                                    16.0,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Campus not found")),
                                  );
                                }
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
