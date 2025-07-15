import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF12A5BC),
      backgroundColor: const Color(0xFF12A5BC).withOpacity(0.2),
      padding: const EdgeInsets.symmetric(vertical: 14),
      side: const BorderSide(color: Color(0xFF12A5BC), width: 1),
      textStyle: const TextStyle(
        fontSize: 15,
        fontFamily: "Poppins",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
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
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
