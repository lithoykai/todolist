import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthController extends ChangeNotifier {
  bool isLogin = true;

  void changeAuth() {
    isLogin = !isLogin;
    print(isLogin);
    notifyListeners();
  }
}
