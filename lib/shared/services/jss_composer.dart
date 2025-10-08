import "../services/app_state.dart";

/// Lines for JSS export, derived from current appState.
/// Later: extend with real groups/rows + guardrails.
List<String> composeJssLines() {
  final credit = switch (appState.creditPref) {
    CreditPref.low     => "CREDIT_PREFERENCE LOW",
    CreditPref.neutral => "CREDIT_PREFERENCE NEUTRAL",
    CreditPref.high    => "CREDIT_PREFERENCE HIGH",
  };
  final leave   = "LEAVE_SLIDE ${appState.leaveDeltaDays >= 0 ? "+" : ""}${appState.leaveDeltaDays}";
  final reserve = "PREFER_RESERVE ${appState.preferReserve ? "ON" : "OFF"}";
  final bank    = "BANK_PROTECTION ${appState.bankProtection ? "ON" : "OFF"}";

  return [credit, leave, reserve, bank];
}

/// Compose full text with CRLF (Windows/JSS friendly).
String composeJssText({bool windowsEol = true}) {
  final eol = windowsEol ? "\r\n" : "\n";
  final s = composeJssLines().join(eol) + eol;
  return s;
}
