import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<void> deleteAllConversation() async {
  try {
    await dio.delete("/conversation//delete-all-conversations");
  } on DioException catch (_) {
    throw Exception('Failed to delete all conversations.');
  }
}

Future<Map<String, String>> getPrivacyAndLegal() async {
  try {
    final response = await dio.get("/general/get-info");

    // Ensure "general" exists and is a non-empty list
    final List<dynamic> generalList = response.data["general"] ?? [];

    if (generalList.isEmpty) {
      throw Exception("No privacy and legal information available.");
    }

    final general = generalList[0] as Map<String, dynamic>;

    return {
      "privacyPolicy":
          general["privacy_policies_mobile"] ?? "No privacy policy available.",
      "termsAndConditions":
          general["terms_conditions_mobile"] ?? "No terms and conditions available.",
    };
  } on DioException catch (_) {
    throw Exception('Failed to fetch privacy and legal information.');
  }
}
