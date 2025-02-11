import 'package:flutter/material.dart';

enum FontSizeOption { size100, size200, size300, size400 }

enum LineHeightOption { height100, height200, height300 }

enum CustomFontWeight { weight400, weight500, weight600, weight700, weight800 }

TextStyle styleText({
  required BuildContext context,
  required FontSizeOption fontSizeOption,
  required LineHeightOption lineHeightOption,
  CustomFontWeight fontWeight = CustomFontWeight.weight400,
}) {
  final fontSizeMap = {
    FontSizeOption.size100: 11.0,
    FontSizeOption.size200: 13.0,
    FontSizeOption.size300: 16.0,
    FontSizeOption.size400: 20.0,
  };

  final lineHeightMap = {
    LineHeightOption.height100: 1.2,
    LineHeightOption.height200: 1.6,
    LineHeightOption.height300: 1.1, // Corrected from 1.10
  };

  final fontWeightMap = {
    CustomFontWeight.weight400: FontWeight.w400,
    CustomFontWeight.weight500: FontWeight.w500,
    CustomFontWeight.weight600: FontWeight.w600,
    CustomFontWeight.weight700: FontWeight.w700,
    CustomFontWeight.weight800: FontWeight.w800,
  };

  final textColor = Theme.of(context).brightness == Brightness.light
      ? const Color(0xFF323232) // Light theme color
      : const Color(0xFFFFFFFF); // Dark theme color

  return TextStyle(
    fontFamily: "Poppins",
    fontSize: fontSizeMap[fontSizeOption],
    height: lineHeightMap[lineHeightOption],
    fontWeight: fontWeightMap[fontWeight],
    color: textColor,
  );
}

// BoxShadow constant
final BoxShadow boxShadow = BoxShadow(
  color: const Color.fromARGB(255, 50, 50, 50).withOpacity(0.1),
  spreadRadius: 2,
  blurRadius: 5,
  offset: const Offset(0, 3),
);
