import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:flutter_switch/flutter_switch.dart';

class VirtualTourPreference extends StatefulWidget {
  const VirtualTourPreference({super.key});

  @override
  State<VirtualTourPreference> createState() => _VirtualTourPreferenceState();
}

class _VirtualTourPreferenceState extends State<VirtualTourPreference> {
  bool isGigaEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () async {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Virtual Tour Preferences",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterSwitch(
              width: 50.0,
              height: 25.0,
              toggleSize: 15.0,
              borderRadius: 20.0,
              activeColor: const Color(0xFF12A5BC),
              inactiveColor: Colors.grey.shade400,
              value: isGigaEnabled,
              onToggle: (value) {
                setState(() {
                  isGigaEnabled = value;
                });
              },
            ),
            const SizedBox(width: 12),
            Flexible(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Colors.black,
                    height: 1.7,
                  ),
                  children: [
                    TextSpan(
                      text: 'Disable Giga: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Toggle Giga\'s presence in your virtual experience',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
