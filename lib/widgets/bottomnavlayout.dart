import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';

class BottomNavLayout extends StatelessWidget {
  final Widget child;
  const BottomNavLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    int getSelectedIndex(BuildContext context) {
      final location = GoRouterState.of(context).uri.toString(); // ✅ Get current path
      if (location == '/explore') return 1;
      if (location == '/chat') return 2;
      if (location == '/profile') return 3;
      return 0; 
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: GNav(
        gap: 5,
        selectedIndex: getSelectedIndex(context),
        onTabChange: (index) {
          final routes = ['/', '/explore', '/chat', '/profile'];
          context.go(routes[index]); // Navigate without losing state
        },
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.explore, text: 'Explore'),
          GButton(icon: Icons.chat, text: 'Chat'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}