import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/forgotpassword.dart';
import 'package:guideurself/features/auth/login.dart';
import 'package:guideurself/features/chat/chatbot.dart';
import 'package:guideurself/features/settings/about.dart';
import 'package:guideurself/features/settings/changepassword.dart';
import 'package:guideurself/features/settings/chatbotpreference.dart';
import 'package:guideurself/features/explore/explore.dart';
import 'package:guideurself/features/home/home.dart';
import 'package:guideurself/features/chat/chatpreview.dart';
import 'package:guideurself/features/layer/authuser.dart';
import 'package:guideurself/features/settings/settings.dart';
import 'package:guideurself/features/settings/virtualtourpreference.dart';
import 'package:guideurself/features/settings/userfeedback.dart';
import 'package:guideurself/screens/featureoverview.dart';
import 'package:guideurself/screens/splash.dart';
import 'package:guideurself/widgets/bottomnavlayout.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/splash",
      pageBuilder: (context, state) => _buildSlidePage(state, const Splash()),
    ),
    GoRoute(
      path: "/feature-overview",
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const FeatureOverview()),
    ),
    GoRoute(
      path: "/login",
      pageBuilder: (context, state) => _buildSlidePage(state, const Login()),
    ),
    GoRoute(
      path: "/forgot-password",
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const ForgotPassword()),
    ),
    GoRoute(
      path: "/auth-layer",
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const AuthLayer()),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildSlidePage(state, const Home()),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
              _buildSlidePage(state, const Explore()),
        ),
        GoRoute(
          path: '/chat',
          pageBuilder: (context, state) =>
              _buildSlidePage(state, const ChatPreview()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              _buildSlidePage(state, const Settings()),
        ),
      ],
    ),
    GoRoute(
      path: '/chatbot',
      pageBuilder: (context, state) => _buildSlidePage(state, const Chatbot()),
    ),
    GoRoute(
      path: '/chatbot-preference',
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const ChatbotPreference()),
    ),
    GoRoute(
      path: '/virtual-preference',
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const VirtualTourPreference()),
    ),
    GoRoute(
      path: '/change-password',
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const Changepassword()),
    ),
    GoRoute(
      path: '/feedback',
      pageBuilder: (context, state) =>
          _buildSlidePage(state, const UserFeedback()),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => _buildSlidePage(state, const About()),
    ),
  ],
);

CustomTransitionPage _buildSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}
