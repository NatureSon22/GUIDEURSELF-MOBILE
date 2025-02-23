import 'package:dio/dio.dart';
import '../models/university_management.dart';

class UniversityManagementService {
  final Dio _dio = Dio();
  final String baseUrl = "https://guideurself-web.onrender.com/api/university/675cdd9756f690410f1473b8"; // Adjust if needed

  Future<UniversityManagement> fetchUniversityDetails() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        return UniversityManagement.fromJson(response.data);
      } else {
        throw Exception("Failed to load university details");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  fetchUniversityManagement() {}
}
