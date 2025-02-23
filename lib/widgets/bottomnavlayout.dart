import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';

class BottomNavLayout extends StatelessWidget {
  final Widget child;
  const BottomNavLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    int getSelectedIndex(BuildContext context) {
      final location = GoRouterState.of(context).uri.toString();
      if (location == '/explore') return 1;
      if (location == '/chat') return 2;
      if (location == '/settings') return 3;
      return 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: const Color(0xFF323232).withOpacity(0.08),
            ),
          ),
        ),
        child: GNav(
          gap: 5,
          selectedIndex: getSelectedIndex(context),
          onTabChange: (index) {
            final routes = ['/', '/explore', '/chat', '/settings'];
            context.go(routes[index]);
          },
          tabs: [
            GButton(
              icon: Icons.home_rounded,
              text: 'Home',
              textStyle: const TextStyle(
                  color: Color(0xFF12A5BC),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
              gap: 8,
              backgroundColor: const Color(0xFF12A5BC).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              iconColor: const Color(0xFF323232).withOpacity(0.55),
              iconActiveColor: const Color(0xFF12A5BC),
            ),
            GButton(
              icon: Icons.explore,
              text: 'Explore',
              textStyle: const TextStyle(
                  color: Color(0xFF12A5BC),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
              gap: 8,
              backgroundColor: const Color(0xFF12A5BC).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              iconColor: const Color(0xFF323232).withOpacity(0.55),
              iconActiveColor: const Color(0xFF12A5BC),
            ),
            GButton(
              icon: Icons.chat_bubble,
              text: 'Chat',
              textStyle: const TextStyle(
                  color: Color(0xFF12A5BC),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
              gap: 8,
              backgroundColor: const Color(0xFF12A5BC).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              iconColor: const Color(0xFF323232).withOpacity(0.55),
              iconActiveColor: const Color(0xFF12A5BC),
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              textStyle: const TextStyle(
                  color: Color(0xFF12A5BC),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
              gap: 8,
              backgroundColor: const Color(0xFF12A5BC).withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              iconColor: const Color(0xFF323232).withOpacity(0.55),
              iconActiveColor: const Color(0xFF12A5BC),
            ),
          ],
        ),
      ),
    );
  }
}
