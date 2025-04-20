import 'package:flutter/foundation.dart';
import 'package:guideurself/services/conversation.dart';

class MessageReviewProvider extends ChangeNotifier {
  final Map<String, bool?> reviewStates = {};

  bool? getReviewState(String messageId) {
    return reviewStates[messageId];
  }

  Future<bool> setReviewState(String messageId, bool isHelpful,
      {String? reason}) async {
    try {
      await reviewIsHelpful(
        messageId: messageId,
        isHelpful: isHelpful,
        reason: reason,
      );

      reviewStates[messageId] = isHelpful;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void resetReviewStates() {
    reviewStates.clear();
    notifyListeners();
  }
}
