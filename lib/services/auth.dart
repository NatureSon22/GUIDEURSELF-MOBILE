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

Future<void> logout() async {
  try {
    await dio.post("/auth/logout");
  } on DioException catch (_) {
    throw Exception('Failed to logout.');
  }
}

Future<Map<String, dynamic>> userAccount() async {
  try {
    final response = await dio.get("/accounts/logged-in-account");
    final user = response.data['user'][0];
    return user;
  } on DioException catch (_) {
    throw Exception('Failed to fetch user account.');
  }
}

Future<Map<String, dynamic>> updatePassword(
    {required String password, required String accountId}) async {
  try {
    final response = await dio.put("/accounts/update-account",
        data: {"password": password, "accountId": accountId});
    final user = response.data;
    return user;
  } on DioException catch (_) {
    throw Exception('Failed to update password.');
  }
}
