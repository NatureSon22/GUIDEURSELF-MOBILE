import 'package:flutter/material.dart';
import 'package:guideurself/services/storage.dart';

class TextScaleProvider extends ChangeNotifier {
  double _scaleFactor = 1.0;
  final StorageService _storageService = StorageService();

  double get scaleFactor => _scaleFactor;

  void setScaleFactor(double scale) {
    _scaleFactor = scale;
    _storageService.saveData(key: "scale", value: scale);
    notifyListeners();
  }
}
