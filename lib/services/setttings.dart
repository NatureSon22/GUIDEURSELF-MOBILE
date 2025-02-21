import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<Map<String, dynamic>> getConversationMessages() async {
  try {
    final response = await dio.get("/general/get-info");
    final privacyPolicy =
        response.data["privacyPolicy"]?.cast<Map<String, dynamic>>() ?? [];
    final termsAndConditions =
        response.data["termsAndConditions"]?.cast<Map<String, dynamic>>() ?? [];

    return {
      "privacyPolicy": privacyPolicy,
      "termsAndConditions": termsAndConditions
    };
  } on DioException catch (_) {
    throw Exception('Failed to fetch messages');
  }
}
