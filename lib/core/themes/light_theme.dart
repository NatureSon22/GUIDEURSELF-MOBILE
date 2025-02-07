import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  primaryColor: const Color(0xFF12A5BC),
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
  ),

  // Text Theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF323232),
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF323232),
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF323232),
    ),
    bodyMedium: TextStyle(
      fontSize: 13,
      color: Color(0xFF323232),
      height: 1.7,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
      color: Color(0xFF323232),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
    border: const OutlineInputBorder(),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF323232)),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF323232)),
    ),
    suffixIconColor: Colors.grey.shade400,
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      backgroundColor: const Color(0xFF12A5BC),
      textStyle: const TextStyle(
        fontSize: 15,
        fontFamily: "Poppins",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  //TextButton theme
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    foregroundColor: const Color(0xFF323232),
    textStyle: const TextStyle(
      fontSize: 11,
      fontFamily: "Poppins",
    ),
  )),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF12A5BC),
      backgroundColor: const Color(0xFF12A5BC).withOpacity(0.05),
      padding: const EdgeInsets.symmetric(vertical: 14),
      side: const BorderSide(color: Color(0xFF12A5BC), width: 2),
      textStyle: const TextStyle(
        fontSize: 15,
        fontFamily: "Poppins",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // checkbox theme
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: const Color(0xFF323232).withOpacity(0.3)),
    overlayColor:
        WidgetStatePropertyAll(const Color(0xFF12A5BC).withOpacity(0.1)),
  ),
);
