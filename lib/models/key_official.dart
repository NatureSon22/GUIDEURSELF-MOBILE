class KeyOfficial {
  final String id;
  final String positionName;
  final String name;
  final String keyOfficialPhotoUrl;
  final String campusId;
  final DateTime dateAdded;

  KeyOfficial({
    required this.id,
    required this.positionName,
    required this.name,
    required this.keyOfficialPhotoUrl,
    required this.campusId,
    required this.dateAdded,
  });

  // Factory constructor to create an instance from JSON
  factory KeyOfficial.fromJson(Map<String, dynamic> json) {
    return KeyOfficial(
      id: json['_id'],
      positionName: json['position_name'],
      name: json['name'],
      keyOfficialPhotoUrl: json['key_official_photo_url'],
      campusId: json['campus_id'],
      dateAdded: DateTime.parse(json['date_added']),
    );
  }
}
