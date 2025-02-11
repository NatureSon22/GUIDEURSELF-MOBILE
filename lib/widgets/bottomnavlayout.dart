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
      if (location == '/profile') return 3;
      return 0;
    }

    return Scaffold(
        body: child,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            gap: 5,
            selectedIndex: getSelectedIndex(context),
            onTabChange: (index) {
              final routes = ['/', '/explore', '/chat', '/profile'];
              context.go(routes[index]);
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                gap: 8,
                backgroundColor: Colors.blue[50],
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              GButton(
                icon: Icons.explore,
                text: 'Explore',
                textStyle: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                gap: 8,
                backgroundColor: Colors.blue[50],
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              GButton(
                icon: Icons.chat_bubble,
                text: 'Chat',
                textStyle: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                gap: 8,
                backgroundColor: Colors.blue[50],
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                textStyle: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                gap: 8,
                backgroundColor: Colors.blue[50],
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ],
          ),
        )
        //: null,
        );
  }
}
