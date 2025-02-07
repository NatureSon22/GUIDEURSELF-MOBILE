import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:guideurself/core/themes/dark_theme.dart';
import 'package:guideurself/core/themes/light_theme.dart';
import 'package:guideurself/routes/router.dart';

final queryClient = QueryClient(defaultQueryOptions: DefaultQueryOptions());

void main() {
  runApp(QueryClientProvider(
    queryClient: queryClient,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GuideURSelf',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
