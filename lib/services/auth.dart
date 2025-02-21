import 'package:dio/dio.dart';
import 'package:guideurself/core/config/dioconfig.dart';

Future<Map<String, dynamic>> login({
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

    printCookies();
    validateUser();

    return response.data;
  } on DioException catch (e) {
    print('Login error: ${e.response?.data ?? e.message}');
    rethrow; // Rethrow the exception to be caught by useMutation's onError
  }
}

Future<Map<String, dynamic>> validateUser() async {
  try {
    final response = await dio.get(
      "/auth/validate-token",
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    return response.data;
  } on DioException catch (e) {
    print('Validate error: ${e.response?.statusCode}');
    rethrow;
  }
}

void printCookies() async {
  final cookies = await persistCookieJar
      .loadForRequest(Uri.parse("https://guideurself-web.onrender.com/api/"));
  if (cookies.isEmpty) {
    print("No cookies stored.");
  } else {
    for (var cookie in cookies) {
      print("Cookie: ${cookie.name} = ${cookie.value}");
    }
  }
}
