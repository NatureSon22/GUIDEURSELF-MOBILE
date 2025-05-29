import 'package:dio/dio.dart';
import '../../models/general_settings.dart';
import 'package:guideurself/core/config/dioconfig.dart';

class GeneralSettingsService {
  // Fetch general settings
  Future<GeneralSettings> fetchGeneralSettings() async {
    try {
      final response = await dio.get("/general/675cdd2056f690410f1473b7")
    .timeout(const Duration(seconds: 10));


      if (response.statusCode == 200 && response.data != null) {
        return GeneralSettings.fromJson(response.data);
      } else {
        throw Exception("Failed to load general settings.");
      }
    } on DioException catch (_) {
      throw Exception('Failed to fetch general settings.');
    }
  }
}
