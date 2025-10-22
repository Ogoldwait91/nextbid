import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  bool _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  void login() {
    if (_loggedIn) return;
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    if (!_loggedIn) return;
    _loggedIn = false;
    notifyListeners();
  }
}
