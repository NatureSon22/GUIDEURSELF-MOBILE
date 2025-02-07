import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/forgotpassword.dart';
import 'package:guideurself/features/auth/login.dart';
import 'package:guideurself/features/explore/explore.dart';
import 'package:guideurself/features/home/home.dart';
import 'package:guideurself/features/chat/chat.dart';
import 'package:guideurself/screens/featureoverview.dart';
import 'package:guideurself/screens/splash.dart';
import 'package:guideurself/widgets/bottomnavlayout.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/splash", builder: (context, state) => const Splash()),
    GoRoute(
        path: "/feature-overview",
        builder: (context, state) => const FeatureOverview()),

    // Auth
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(
        path: "/forgot-password",
        builder: (context, state) => const ForgotPassword()),

    // Home
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPage(state, const Home()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) => _buildPage(state, const Explore()),
        ),
        GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => _buildPage(state, const Chat()),
            routes: const [
              // sample route for nested routes
              // GoRoute(
              //     path: "/chatbot", builder: (context, state) => const Chat()),
            ]),
      ],
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
