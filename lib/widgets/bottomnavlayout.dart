import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/providers/bottomnav.dart';
import 'package:guideurself/services/storage.dart';
import 'package:provider/provider.dart';

class BottomNavLayout extends StatefulWidget {
  final Widget child;
  const BottomNavLayout({super.key, required this.child});
  static final StorageService storage = StorageService();

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).path;
    switch (location) {
      case '/explore':
        return 1;
      case '/chat':
      case '/chatbot':
        return 2;
      case '/settings':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final providerIndex = context.watch<BottomNavProvider>().index;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: const Color(0xFF323232).withOpacity(0.08)),
          ),
        ),
        child: GNav(
          gap: 5,
          selectedIndex: providerIndex,
          onTabChange: (index) async {
            final hasVisited =
                await BottomNavLayout.storage.getData(key: "visited-chat") ??
                    false;

            final routes = hasVisited
                ? ['/', '/explore', '/chatbot', '/settings']
                : ['/', '/explore', '/chat', '/settings'];

            if (index == 2) {
              await BottomNavLayout.storage
                  .saveData(key: "visited-chat", value: true);
            }

            if (context.mounted) {
              final current = GoRouterState.of(context).name;

              if (routes[index] != current) {
                context.push(routes[index], extra: {'prev': providerIndex});
                debugPrint("prev index: $providerIndex");
              }
            }

            bottomNavProvider.setIndex(index: index == 2 ? 0 : index);
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
