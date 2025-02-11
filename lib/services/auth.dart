import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<void> login({
  required String email,
  required String password,
  required bool rememberMe,
}) async {
  try {
    final response = await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
        "rememberMe": rememberMe,
      },
    );

    print('Login successful: ${response.data}');
  } on DioException catch (e) {
    print('Login error: ${e.response?.data ?? e.message}');
  }
}
