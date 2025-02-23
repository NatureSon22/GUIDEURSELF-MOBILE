import 'package:flutter/foundation.dart';

class AccountProvider extends ChangeNotifier {
  Map<String, dynamic> account = {};

  void setAccount({required Map<String, dynamic> account}) {
    this.account = account;
    notifyListeners();
  }

  void resetAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    account = {};
    notifyListeners();
  }
}
