import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import '../models/campus_model.dart';

class CampusService {
  Future<List<Campus>> fetchAllCampuses() async {
    try {
      final response = await dio.get("/campuses");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Campus.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load campuses.");
      }
    } on DioException catch (e) {
      throw Exception("Error fetching campuses: ${e.message}");
    }
  }

  Future<Campus> fetchCampusById(String campusId) async {
    try {
      final response = await dio.get("/campuses/$campusId");

      if (response.statusCode == 200) {
        return Campus.fromJson(response.data);
      } else {
        throw Exception("Failed to load campus details.");
      }
    } on DioException catch (e) {
      throw Exception("Error fetching campus: ${e.message}");
    }
  }
}
