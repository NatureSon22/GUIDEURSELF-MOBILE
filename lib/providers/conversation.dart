import 'package:flutter/material.dart';

class ConversationProvider extends ChangeNotifier {
  Map<String, dynamic> conversation = {};
  bool isNewConversation = true;

  void setConversation(
      {required Map<String, dynamic> conversation, bool? isNew}) {
    this.conversation = conversation;
    isNewConversation = isNew ?? false;
    notifyListeners();
  }

  void resetConversation() {
    debugPrint("Resetting conversation...");
    conversation = <String, dynamic>{};
    isNewConversation = true;
    notifyListeners();
  }
}
