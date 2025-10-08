import "package:flutter/foundation.dart";

enum CreditPref { low, neutral, high }

class AppState extends ChangeNotifier {
  CreditPref creditPref = CreditPref.neutral;
  int leaveDeltaDays = 0; // -3..+3
  bool preferReserve = false;
  bool bankProtection = false;

  void setCreditPref(CreditPref v) { creditPref = v; notifyListeners(); }
  void setLeaveDelta(int v) { leaveDeltaDays = v; notifyListeners(); }
  void setPreferReserve(bool v) { preferReserve = v; notifyListeners(); }
  void setBankProtection(bool v) { bankProtection = v; notifyListeners(); }
}

final appState = AppState();
