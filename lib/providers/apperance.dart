import 'package:flutter/material.dart';

class AppearanceProvider extends ChangeNotifier {
  bool isDarkMode = false;
  double scaleFactor = 1.0;

  void setDarkMode(value) {
    isDarkMode = value;
    notifyListeners();
  }

  void setScaleFactor(value) {
    scaleFactor = value;
    notifyListeners();
  }
}
