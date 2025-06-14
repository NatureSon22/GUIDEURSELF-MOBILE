import 'package:flutter/foundation.dart';

class Transcribing extends ChangeNotifier {
  bool isTranscribing = false;

  void setIsTranscribing(bool value) {
    isTranscribing = value;
    notifyListeners();
  }

  void resetIsTranscribing() {
    isTranscribing = false;
    notifyListeners();
  }
}
