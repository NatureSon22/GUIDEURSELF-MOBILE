// Marker Model
class Marker {
  final String id; // Renamed from _id
  final String markerName;
  final double latitude;
  final double longitude;
  final String markerDescription;
  final String category;
  final String markerPhotoUrl;
  final DateTime dateAdded;

  Marker({
    required this.id, // Updated
    required this.markerName,
    required this.latitude,
    required this.longitude,
    required this.markerDescription,
    required this.category,
    required this.markerPhotoUrl,
    required this.dateAdded,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['_id'] ?? "", // Updated
      markerName: json['marker_name'] ?? "",
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      markerDescription: json['marker_description'] ?? "",
      category: json['category'] ?? "",
      markerPhotoUrl: json['marker_photo_url'] ?? "",
      dateAdded:
          DateTime.parse(json['date_added'] ?? DateTime.now().toString()),
    );
  }

  get floorName => null;

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Updated
      'marker_name': markerName,
      'latitude': latitude,
      'longitude': longitude,
      'marker_description': markerDescription,
      'category': category,
      'marker_photo_url': markerPhotoUrl,
      'date_added': dateAdded.toIso8601String(),
    };
  }
}

class Floor {
  final String id; // Renamed from _id
  final String floorName;
  final String floorPhotoUrl;
  final List<Marker> markers;
  final int order;

  Floor({
    required this.id, // Updated
    required this.floorName,
    required this.floorPhotoUrl,
    required this.markers,
    required this.order,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['_id'] ?? "", // Updated
      floorName: json['floor_name'] ?? "",
      floorPhotoUrl: json['floor_photo_url'] ?? "",
      markers: (json['markers'] as List<dynamic>? ?? [])
          .map((e) => Marker.fromJson(e))
          .toList(),
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Updated
      'floor_name': floorName,
      'floor_photo_url': floorPhotoUrl,
      'markers': markers.map((m) => m.toJson()).toList(),
      'order': order,
    };
  }
}

class Program {
  final String programName;
  final List<String> majors;

  Program({
    required this.programName,
    required this.majors,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      programName: json['program_name'] ?? "",
      majors: List<String>.from(json['majors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'program_name': programName,
      'majors': majors,
    };
  }
}

// Program Schema
class ProgramSchema {
  final String programTypeId;
  final List<Program> programs;

  ProgramSchema({
    required this.programTypeId,
    required this.programs,
  });

  factory ProgramSchema.fromJson(Map<String, dynamic> json) {
    return ProgramSchema(
      programTypeId: json['program_type_id'] ?? "",
      programs: (json['programs'] as List<dynamic>? ?? [])
          .map((e) => Program.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'program_type_id': programTypeId,
      'programs': programs.map((p) => p.toJson()).toList(),
    };
  }
}

// Campus Model
class Campus {
  final String id; // Renamed from _id
  final String campusName;
  final String campusCode;
  final String campusPhoneNumber;
  final String campusEmail;
  final String campusAddress;
  final String campusCoverPhotoUrl;
  final String campusAbout;
  final List<ProgramSchema> campusPrograms;
  final String latitude;
  final String longitude;
  final DateTime dateAdded;
  final List<Floor> floors;

  Campus({
    required this.id, // Updated
    required this.campusName,
    required this.campusCode,
    required this.campusPhoneNumber,
    required this.campusEmail,
    required this.campusAddress,
    required this.campusCoverPhotoUrl,
    required this.campusAbout,
    required this.campusPrograms,
    required this.latitude,
    required this.longitude,
    required this.dateAdded,
    required this.floors,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['_id'] ?? "", // Updated
      campusName: json['campus_name'] ?? "",
      campusCode: json['campus_code'] ?? "",
      campusPhoneNumber: json['campus_phone_number'] ?? "",
      campusEmail: json['campus_email'] ?? "",
      campusAddress: json['campus_address'] ?? "",
      campusCoverPhotoUrl: json['campus_cover_photo_url'] ?? "",
      campusAbout: json['campus_about'] ?? "",
      campusPrograms: (json['campus_programs'] as List<dynamic>? ?? [])
          .map((e) => ProgramSchema.fromJson(e))
          .toList(),
      latitude: json['latitude'] ?? "",
      longitude: json['longitude'] ?? "",
      dateAdded:
          DateTime.parse(json['date_added'] ?? DateTime.now().toString()),
      floors: (json['floors'] as List<dynamic>? ?? [])
          .map((e) => Floor.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Updated
      'campus_name': campusName,
      'campus_code': campusCode,
      'campus_phone_number': campusPhoneNumber,
      'campus_email': campusEmail,
      'campus_address': campusAddress,
      'campus_cover_photo_url': campusCoverPhotoUrl,
      'campus_about': campusAbout,
      'campus_programs': campusPrograms.map((p) => p.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'date_added': dateAdded.toIso8601String(),
      'floors': floors.map((f) => f.toJson()).toList(),
    };
  }
}
