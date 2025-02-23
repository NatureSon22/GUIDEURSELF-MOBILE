import 'package:dio/dio.dart';
import '../models/key_official.dart';

class KeyOfficialService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://guideurself-web.onrender.com/api"; // Change if needed

  // Fetch all key officials
  Future<List<KeyOfficial>> fetchKeyOfficials() async {
    try {
      Response response = await _dio.get("$_baseUrl/keyofficials");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => KeyOfficial.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load key officials");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Fetch a single key official by ID
  Future<KeyOfficial> fetchKeyOfficialById(String id) async {
    try {
      Response response = await _dio.get("$_baseUrl/keyofficials/$id");
      if (response.statusCode == 200) {
        return KeyOfficial.fromJson(response.data);
      } else {
        throw Exception("Failed to load key official");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
