import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import '../models/university_management.dart';

Future<UniversityManagement> fetchUniversityDetails() async {
  try {
    final response = await dio.get("/university/675cdd9756f690410f1473b8");

    if (response.statusCode == 200) {
      return UniversityManagement.fromJson(response.data);
    } else {
      throw Exception("Failed to load university details.");
    }
  } on DioException catch (_) {
    throw Exception('Failed to fetch university details.');
  }
}
