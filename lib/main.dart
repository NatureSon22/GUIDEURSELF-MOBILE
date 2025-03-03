import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import 'package:guideurself/core/themes/dark_theme.dart';
import 'package:guideurself/core/themes/light_theme.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/routes/router.dart';
import 'package:guideurself/services/storage.dart';
import 'package:provider/provider.dart';

final queryClient = QueryClient(defaultQueryOptions: DefaultQueryOptions());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDio();
  await StorageService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => LoadingProvider())
      ],
      child: QueryClientProvider(
        queryClient: queryClient,
        child: const MyApp(),
      ),
    ),
  );
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
