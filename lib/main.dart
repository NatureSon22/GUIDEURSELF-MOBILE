import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:guideurself/core/config/dioconfig.dart';
import 'package:guideurself/core/themes/dark_theme.dart';
import 'package:guideurself/core/themes/light_theme.dart';
import 'package:guideurself/providers/account.dart';
import 'package:guideurself/providers/apperance.dart';
import 'package:guideurself/providers/bottomnav.dart';
import 'package:guideurself/providers/conversation.dart';
import 'package:guideurself/providers/loading.dart';
import 'package:guideurself/providers/messagechat.dart';
import 'package:guideurself/providers/messagereview.dart';
import 'package:guideurself/providers/textscale.dart';
import 'package:guideurself/providers/transcribing.dart';
import 'package:guideurself/routes/router.dart';
import 'package:guideurself/services/socket.dart';
import 'package:guideurself/services/storage.dart';
import 'package:provider/provider.dart';
import 'dart:async';

final queryClient = QueryClient(defaultQueryOptions: DefaultQueryOptions());

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await setupDio();
      await StorageService().init();
    } catch (e) {
      debugPrint("Error during initialization: $e");
    }

    final socketService = SocketService();
    socketService.connect();
    final storage = StorageService();
    final hasVisitedSplash = storage.getData(key: "hasVisitedSplash") == true;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ConversationProvider()),
          ChangeNotifierProvider(create: (context) => AccountProvider()),
          ChangeNotifierProvider(create: (context) => LoadingProvider()),
          ChangeNotifierProvider(create: (context) => Transcribing()),
          ChangeNotifierProvider(create: (context) => MessageChatProvider()),
          ChangeNotifierProvider(create: (context) => BottomNavProvider()),
          ChangeNotifierProvider(create: (context) => MessageReviewProvider()),
          ChangeNotifierProvider(create: (context) => AppearanceProvider()),
          ChangeNotifierProvider(create: (context) => TextScaleProvider())
        ],
        child: QueryClientProvider(
          queryClient: queryClient,
          child: MyApp(
            initialRoute: hasVisitedSplash ? "/auth-layer" : "/splash",
          ),
        ),
      ),
    );
  }, (error, stackTrace) {
    debugPrint("Uncaught error: $error\n$stackTrace");
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GuideURSelf',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: context.watch<AppearanceProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: router(initialRoute),
    );
  }
}
