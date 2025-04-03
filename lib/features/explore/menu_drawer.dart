import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 110,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 206, 206, 206), width: 1.0),
                  ),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'University of Rizal System',
                        style: TextStyle(
                          fontFamily: "Cinzel",
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Nurturing Tomorrow's Noblest",
                        style: TextStyle(
                          fontFamily: "CinzelDecorative",
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCenteredListTile(context, "History", "/history"),
                  _buildCenteredListTile(
                      context, "Logo & Vector", "/logo-vector"),
                  _buildCenteredListTile(context,
                      "Vision, Mission, and Core Values", "/vision-mission"),
                  _buildCenteredListTile(
                      context, "Key Officials", "/key-officials"),
                  _buildCenteredListTile(
                      context, "Campus Location", "/campus-location"),
                  _buildCenteredListTile(
                      context, "Virtual Campus Tour", "/virtual-tour"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to create a centered ListTile with GoRouter navigation
  Widget _buildCenteredListTile(
      BuildContext context, String title, String path) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        context.push(path); // Navigate using GoRouter
      },
    );
  }
}
