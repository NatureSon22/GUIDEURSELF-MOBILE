import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import 'package:guideurself/core/constants/projecttype.dart';

Future<void> addFeedback(
    {required String feedback,
    required int rating,
    required ProjectType type}) async {
  try {
    await dio.post(
      "/feedback/add-feedback",
      data: {"feedback": feedback, "rating": rating, "type": type.name},
    );
  } on DioException catch (_) {
    throw Exception("Failed to add feedback.");
  }
}
