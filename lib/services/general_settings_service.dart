import 'dart:convert';
import 'package:dio/dio.dart';
import '../../models/general_settings.dart';

class GeneralSettingsService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://guideurself-web.onrender.com/api/generalsettings";

  Future<GeneralSettings> fetchGeneralSettings() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        return GeneralSettings.fromJson(response.data);
      } else {
        throw Exception("Failed to load general settings");
      }
    } catch (e) {
      throw Exception("Error fetching general settings: $e");
    }
  }
}
