import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/features/auth/forgotpassword.dart';
import 'package:guideurself/features/auth/login.dart';
import 'package:guideurself/features/chat/chatbot.dart';
import 'package:guideurself/features/settings/editprofile.dart';
import 'package:guideurself/features/settings/about.dart';
import 'package:guideurself/features/settings/changepassword.dart';
import 'package:guideurself/features/settings/chatbotpreference.dart';
import 'package:guideurself/features/explore/explore.dart';
import 'package:guideurself/features/home/home.dart';
import 'package:guideurself/features/chat/chatpreview.dart';
import 'package:guideurself/features/layer/authuser.dart';
import 'package:guideurself/features/settings/privacylegal.dart';
import 'package:guideurself/features/settings/settings.dart';
import 'package:guideurself/features/settings/virtualtourpreference.dart';
import 'package:guideurself/features/settings/userfeedback.dart';
import 'package:guideurself/screens/featureoverview.dart';
import 'package:guideurself/screens/splash.dart';
import 'package:guideurself/widgets/bottomnavlayout.dart';

GoRouter router(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
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
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: "/forgot-password",
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: "/auth-layer",
        builder: (context, state) => const AuthLayer(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BottomNavLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                _buildSlidePage(state, const Home()),
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

      // Other routes with transitions
      GoRoute(
        path: '/chatbot',
        pageBuilder: (context, state) =>
            _buildSlidePage(state, const Chatbot()),
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) =>
            _buildSlidePage(state, const EditProfile()),
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
        path: '/privacy-legal',
        pageBuilder: (context, state) =>
            _buildSlidePage(state, const PrivacyLegal()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => _buildSlidePage(state, const About()),
      ),
    ],
  );
}

// Custom transition function for non-auth routes
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
