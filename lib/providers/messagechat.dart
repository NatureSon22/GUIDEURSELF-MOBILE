import 'package:flutter/material.dart';

class MessageChatProvider with ChangeNotifier {
  Map<String, dynamic> message = {};

  void setMessage({required Map<String, dynamic> message}) {
    this.message = message;
    notifyListeners();
  }

  void resetMessage() {
    message = <String, dynamic>{};
    notifyListeners();
  }
}
