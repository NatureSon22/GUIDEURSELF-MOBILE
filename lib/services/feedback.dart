import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<void> addFeedback(
    {required String feedback, required int rating}) async {
  try {
    await dio.post(
      "/feedback/add-feedback",
      data: {"feedback": feedback, "rating": rating},
    );
  } on DioException catch (_) {
    throw Exception("Failed to add feedback.");
  }
}
