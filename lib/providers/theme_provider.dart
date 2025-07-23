import 'package:flutter/material.dart';
import 'package:guideurself/services/storage.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final StorageService _storage = StorageService();

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    await _storage.init();
    _isDarkMode = _storage.getData(key: 'darkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    _storage.saveData(key: 'darkMode', value: isDark);
    notifyListeners();
  }
}
