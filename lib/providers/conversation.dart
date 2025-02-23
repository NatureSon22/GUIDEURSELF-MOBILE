import 'package:flutter/material.dart';

class ConversationProvider extends ChangeNotifier {
  Map<String, dynamic> conversation = {};

  void setConversation({required Map<String, dynamic> conversation}) {
    this.conversation = conversation;
    notifyListeners();
  }

  void resetConversation() async {
    await Future.delayed(const Duration(seconds: 1));
    conversation = {};
    notifyListeners();
  }
}
