import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/dark_theme.dart';
import 'package:guideurself/core/themes/light_theme.dart';
import 'package:guideurself/routes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
