import 'package:flutter/material.dart';
import 'package:guideurself/services/storage.dart';

class AppearanceProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double scaleFactor = 1.0;
  final StorageService _storage = StorageService();

  bool get isDarkMode => _isDarkMode;

  AppearanceProvider() {
    _initDarkMode();
  }

  Future<void> _initDarkMode() async {
    await _storage.init();
    _isDarkMode = _storage.getData(key: 'darkMode') ?? false;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _storage.saveData(key: 'darkMode', value: value);
    notifyListeners();
  }

  void setScaleFactor(value) {
    scaleFactor = value;
    notifyListeners();
  }
}
