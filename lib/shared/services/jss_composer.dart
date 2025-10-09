import "../services/app_state.dart";

/// Simple row grammar (placeholder): A–Z, 0–9, space, _ + - . , / : ( ) # = and backslash
final RegExp _rowRe = RegExp(r'^[A-Z0-9 _+\-.,/:()#=\\]{1,80}$');

class BidValidation {
  final int groups;
  final int rows;
  final List<String> errors;
  const BidValidation(this.groups, this.rows, this.errors);
  bool get ok => errors.isEmpty;
}

BidValidation validateBid() {
  final errs = <String>[];
  if (appState.groups.length > 15) errs.add("Too many groups (max 15).");
  final total = appState.totalRows;
  if (total > 40) errs.add("Too many rows across groups (max 40).");
  for (var gi = 0; gi < appState.groups.length; gi++) {
    final g = appState.groups[gi];
    for (var ri = 0; ri < g.rows.length; ri++) {
      final t = g.rows[ri].text.trim().toUpperCase();
      if (t.isEmpty) continue;
      if (!_rowRe.hasMatch(t)) {
        errs.add("Invalid row in ${g.name} #${ri + 1}: '$t'");
      }
    }
  }
  return BidValidation(appState.groups.length, total, errs);
}

/// Global (from Pre-Process) followed by group rows (order preserved).
List<String> composeJssLines() {
  final credit = switch (appState.creditPref) {
    CreditPref.low     => "CREDIT_PREFERENCE LOW",
    CreditPref.neutral => "CREDIT_PREFERENCE NEUTRAL",
    CreditPref.high    => "CREDIT_PREFERENCE HIGH",
  };
  final leave   = "LEAVE_SLIDE ${appState.leaveDeltaDays >= 0 ? "+" : ""}${appState.leaveDeltaDays}";
  final reserve = "PREFER_RESERVE ${appState.preferReserve ? "ON" : "OFF"}";
  final bank    = "BANK_PROTECTION ${appState.bankProtection ? "ON" : "OFF"}";

  final lines = <String>[credit, leave, reserve, bank];

  for (final g in appState.groups) {
    lines.add("; ${g.name}");
    for (final r in g.rows) {
      final t = r.text.trim();
      if (t.isNotEmpty) lines.add(t.toUpperCase());
    }
  }
  return lines;
}

/// Compose full text with CRLF (Windows/JSS friendly).
String composeJssText({bool windowsEol = true}) {
  final eol = windowsEol ? "\r\n" : "\n";
  return composeJssLines().join(eol) + eol;
}
