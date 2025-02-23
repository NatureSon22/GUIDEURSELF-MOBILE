class UniversityManagement {
  final String? universityLogoUrl;
  final String? universityVectorUrl;
  final String? universityHistory;
  final String? universityVision;
  final String? universityMission;
  final String? universityCoreValues;

  UniversityManagement({
    this.universityLogoUrl,
    this.universityVectorUrl,
    this.universityHistory,
    this.universityVision,
    this.universityMission,
    this.universityCoreValues,
  });

  // Factory method to create an instance from JSON
  factory UniversityManagement.fromJson(Map<String, dynamic> json) {
    return UniversityManagement(
      universityLogoUrl: json['university_logo_url'],
      universityVectorUrl: json['university_vector_url'],
      universityHistory: json['university_history'],
      universityVision: json['university_vision'],
      universityMission: json['university_mission'],
      universityCoreValues: json['university_core_values'],
    );
  }
}
