import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import '../models/key_official.dart';

// Fetch all key officials
Future<List<KeyOfficial>> fetchKeyOfficials() async {
  try {
    final response = await dio.get("/keyofficials");

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((json) => KeyOfficial.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load key officials.");
    }
  } on DioException catch (_) {
    throw Exception('Failed to fetch key officials.');
  }
}

// Fetch a single key official by ID
Future<KeyOfficial> fetchKeyOfficialById(String id) async {
  try {
    final response = await dio.get("/keyofficials/$id");

    if (response.statusCode == 200 && response.data != null) {
      return KeyOfficial.fromJson(response.data);
    } else {
      throw Exception("Key official not found.");
    }
  } on DioException catch (_) {
    throw Exception('Failed to fetch key official.');
  }
}
