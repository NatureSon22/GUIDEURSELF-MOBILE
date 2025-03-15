import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/services/storage.dart';

class BottomNavLayout extends StatelessWidget {
  final Widget child;
  const BottomNavLayout({super.key, required this.child});
  static final StorageService storage = StorageService();

  int getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).path;
    if (location == '/explore') return 1;
    if (location == '/chat') return 2;
    if (location == '/settings') return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: const Color(0xFF323232).withOpacity(0.08)),
          ),
        ),
        child: GNav(
          gap: 5,
          selectedIndex: getSelectedIndex(context),
          onTabChange: (index) async {
            final hasVisited = storage.getData(key: "visited-chat");

            final routes = hasVisited == true
                ? ['/', '/explore', '/chatbot', '/settings']
                : ['/', '/explore', '/chat', '/settings'];

            if (index == 2) {
              storage.saveData(key: "visited-chat", value: true);
            }

            context.go(routes[index]);
          },
          tabs: [
            _buildNavItem(Icons.home_rounded, 'Home'),
            _buildNavItem(Icons.explore, 'Explore'),
            _buildNavItem(Icons.chat_bubble, 'Chat'),
            _buildNavItem(Icons.settings, 'Settings'),
          ],
        ),
      ),
    );
  }

  GButton _buildNavItem(IconData icon, String label) {
    return GButton(
      icon: icon,
      text: label,
      textStyle: const TextStyle(
        color: Color(0xFF12A5BC),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      gap: 8,
      backgroundColor: const Color(0xFF12A5BC).withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      iconColor: const Color(0xFF323232).withOpacity(0.55),
      iconActiveColor: const Color(0xFF12A5BC),
    );
  }
}
