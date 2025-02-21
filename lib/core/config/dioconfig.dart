import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: "https://guideurself-web.onrender.com/api",
    headers: {
      "Content-Type": "application/json",
    },
  ),
);

late PersistCookieJar persistCookieJar;

Future<void> setupDio() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookiesPath = "${appDocDir.path}/cookies/";

  persistCookieJar = PersistCookieJar(storage: FileStorage(cookiesPath));

  dio.interceptors.add(CookieManager(persistCookieJar));
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    responseHeader: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
}
