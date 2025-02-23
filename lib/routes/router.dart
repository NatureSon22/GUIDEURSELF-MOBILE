import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/forgotpassword.dart';
import 'package:guideurself/features/auth/login.dart';
import 'package:guideurself/features/chat/chatbot.dart';
import 'package:guideurself/features/explore/explore.dart';
import 'package:guideurself/features/home/home.dart';
import 'package:guideurself/features/chat/chatpreview.dart';
import 'package:guideurself/screens/featureoverview.dart';
import 'package:guideurself/screens/splash.dart';
import 'package:guideurself/widgets/bottomnavlayout.dart';

final GoRouter router = GoRouter(
  initialLocation: "/chatbot",
  routes: [
    // Splash & Overview Screens
    GoRoute(path: "/splash", builder: (context, state) => const Splash()),
    GoRoute(
        path: "/feature-overview",
        builder: (context, state) => const FeatureOverview()),

    // Auth Screens
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(
        path: "/forgot-password",
        builder: (context, state) => const ForgotPassword()),

    ShellRoute(
      builder: (context, state, child) {
        return BottomNavLayout(
            child: child); // This will persist for the primary routes
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPage(state, const Home()),
        ),
        GoRoute(
          path: '/chat',
          pageBuilder: (context, state) => _buildPage(state, const ChatPreview()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
              _buildPage(state, const Explore()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPage(
              state, const Placeholder()), // Add your profile widget here
        ),
      ],
    ),

    // Chat bot
    GoRoute(
      path: '/chatbot',
      pageBuilder: (context, state) => _buildPage(state, const Chatbot()),
    ),
  ],
);

CustomTransitionPage _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0), // Start from right
          end: Offset.zero, // Slide to the center
        ).animate(animation),
        child: child,
      );
    },
  );
}
