import 'package:flutter/material.dart';
import 'package:guideurself/core/themes/style.dart';

class MessageDrawer extends StatelessWidget {
  const MessageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        children: [
          Container(
            height: 60,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF323232).withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.menu),
                ),
                Text(
                  'History',
                  textAlign: TextAlign.center,
                  style: styleText(
                      context: context,
                      fontSizeOption: FontSizeOption.size300,
                      lineHeightOption: LineHeightOption.height100),
                ),
                const SizedBox(),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
