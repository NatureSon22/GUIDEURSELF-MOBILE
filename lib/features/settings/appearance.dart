import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:guideurself/core/themes/style.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:guideurself/providers/apperance.dart'; // Make sure this is correctly spelled

class Appearance extends StatefulWidget {
  const Appearance({super.key});

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  double scaleFactor = 1.0;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Load isDarkMode from provider
    isDarkMode = context.read<AppearanceProvider>().isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: const Color(0xFF323232).withOpacity(0.2),
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.go("/settings");
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
        title: Text(
          "Appearance",
          style: styleText(
            context: context,
            fontSizeOption: 17.0,
            fontWeight: CustomFontWeight.weight500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appearance settings saved')),
              );
            },
            child: Text(
              "Save",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF323232).withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          children: [
            const Gap(35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Light mode",
                  style: TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.light_mode,
                      size: 19,
                      color: const Color(0xFF323232).withOpacity(0.6),
                    ),
                    const Gap(15),
                    FlutterSwitch(
                      width: 50.0,
                      height: 25.0,
                      toggleSize: 15.0,
                      borderRadius: 20.0,
                      activeColor: const Color(0xFF12A5BC),
                      inactiveColor: Colors.grey.shade400,
                      value: isDarkMode,
                      onToggle: (value) {
                        context
                            .read<AppearanceProvider>()
                            .toggleDarkMode(value);
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                    const Gap(15),
                    Icon(
                      Icons.dark_mode,
                      size: 19,
                      color: const Color(0xFF323232).withOpacity(0.6),
                    )
                  ],
                )
              ],
            ),
            const Gap(40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Font Scaling ($scaleFactor%)",
                  style: const TextStyle(fontSize: 14),
                ),
                const Gap(10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF12A5BC),
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: const Color(0xFF12A5BC),
                  ),
                  child: Slider(
                    value: scaleFactor,
                    min: 1.0,
                    max: 1.5,
                    divisions: 5,
                    onChanged: (value) {
                      setState(() {
                        scaleFactor = value;
                      });
                    },
                  ),
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sample Text",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,
                      color: const Color(0xFF323232).withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
