import 'package:flutter/material.dart';

// Titles
const TextStyle headerText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

const TextStyle subHeaderText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const TextStyle bodyText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
);

const TextStyle captionText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 14,
  color: Colors.grey,
);

final ButtonStyle primary = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(18, 165, 188, 1),
  textStyle:
      const TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
);
