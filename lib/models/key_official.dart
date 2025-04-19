class KeyOfficial {
  final String id;
  final String positionName;
  final String name;
  final String keyOfficialPhotoUrl;
  final String? campusName;
  final String? collegeName;
  final DateTime dateAdded;

  KeyOfficial({
    required this.id,
    required this.positionName,
    required this.name,
    required this.keyOfficialPhotoUrl,
    this.campusName,
    this.collegeName,
    required this.dateAdded,
  });

  // Factory constructor to create an instance from JSON
  factory KeyOfficial.fromJson(Map<String, dynamic> json) {
    return KeyOfficial(
      id: json['_id'],
      positionName: json['position_name'],
      name: json['name'],
      keyOfficialPhotoUrl: json['key_official_photo_url'],
      campusName: json['campus_name'],
      collegeName: json['college_name'],
      dateAdded: DateTime.parse(json['date_added']),
    );
  }
}
