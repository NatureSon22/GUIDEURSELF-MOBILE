import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int index = 0;

  void setIndex({required index}) {
    this.index = index;
    notifyListeners();
  }

  void resetIndex() {
    index = 0;
    notifyListeners();
  }
}
