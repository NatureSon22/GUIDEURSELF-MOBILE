import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier {
  bool isGeneratingResponse = false;
  Map<String, dynamic> account = {};

  void setIsGeneratingResponse(bool value) {
    isGeneratingResponse = value;
    notifyListeners();
  }

  void resetIsGeneratingResponse() {
    isGeneratingResponse = false;
  }
}
