import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<List<Map<String, dynamic>>> chatHeads() async {
  try {
    final response = await dio.get("/chats/heads");
    final List<dynamic> heads = response.data['chatHeads'] ?? [];
    return heads.map((e) => e as Map<String, dynamic>).toList();
  } on DioException catch (e) {
    print("Error fetching chat heads: ${e.message}");
    throw Exception('Failed to get chat heads.');
  }
}
