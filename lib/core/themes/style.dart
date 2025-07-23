import 'package:flutter/material.dart';

enum FontSizeOption { size100, size200, size300, size400 }

enum LineHeightOption { height100, height200, height300 }

enum CustomFontWeight { weight400, weight500, weight600, weight700, weight800 }

TextStyle styleText({
  required BuildContext context,
  dynamic fontSizeOption, // Accept both FontSizeOption or double
  LineHeightOption lineHeightOption = LineHeightOption.height200,
  CustomFontWeight fontWeight = CustomFontWeight.weight400,
  Color color = const Color(0xFF323232),
  double scaleFactor = 1.0,
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
    LineHeightOption.height300: 1.1,
  };

  final fontWeightMap = {
    CustomFontWeight.weight400: FontWeight.w400,
    CustomFontWeight.weight500: FontWeight.w500,
    CustomFontWeight.weight600: FontWeight.w600,
    CustomFontWeight.weight700: FontWeight.w700,
    CustomFontWeight.weight800: FontWeight.w800,
  };

  // Determine font size based on input type
  final fontSize = (fontSizeOption is FontSizeOption
          ? fontSizeMap[fontSizeOption]
          : fontSizeOption) *
      scaleFactor;

  final textColor = Theme.of(context).brightness == Brightness.light
      ? color
      : (color == const Color(0xFF323232) ? const Color(0xFFFFFFFF) : color);

  return TextStyle(
    fontFamily: "Poppins",
    fontSize: fontSize,
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
