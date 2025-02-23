class GeneralSettings {
  final String? generalLogoUrl;
  final String? generalAbout;
  final String? privacyPolicies;
  final String? termsConditions;

  GeneralSettings({
    this.generalLogoUrl,
    this.generalAbout,
    this.privacyPolicies,
    this.termsConditions,
  });

  // Factory method to create an instance from JSON
  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      generalLogoUrl: json['general_logo_url'],
      generalAbout: json['general_about'],
      privacyPolicies: json['privacy_policies'],
      termsConditions: json['terms_conditions'],
    );
  }
}
