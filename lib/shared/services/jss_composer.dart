import "../services/app_state.dart";

/// Simple row grammar (placeholder): A–Z, 0–9, space, _ + - . , / : ( ) # = and backslash
final RegExp _rowRe = RegExp(r'^[A-Z0-9 _+\-.,/:()#=\\]{1,80}$');
final RegExp _bankRe = RegExp(r'^BANK_PROTECTION(?:\s+(ON|OFF))?$');

bool _isBankLine(String t) => _bankRe.hasMatch(t);

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

  // Detect duplicates and forbidden BANK_PROTECTION in groups
  final seen = <String>{};
  for (var gi = 0; gi < appState.groups.length; gi++) {
    final g = appState.groups[gi];
    for (var ri = 0; ri < g.rows.length; ri++) {
      final t = g.rows[ri].text.trim().toUpperCase();
      if (t.isEmpty) continue;

      if (_isBankLine(t)) {
        errs.add("Remove BANK_PROTECTION from ${g.name} row #${ri + 1}; use the Pre-Process toggle.");
        continue;
      }

      if (!_rowRe.hasMatch(t)) {
        errs.add("Invalid row in ${g.name} #${ri + 1}: '$t'");
      } else if (seen.contains(t)) {
        errs.add("Duplicate row (will be de-duped on export): '$t'");
      } else {
        seen.add(t);
      }
    }
  }
  return BidValidation(appState.groups.length, total, errs);
}

/// Global (from Pre-Process) followed by group rows (order preserved),
/// with BANK_PROTECTION forced from toggle and duplicates removed.
List<String> composeJssLines() {
  // Global directives (always first)
  final credit = switch (appState.creditPref) {
    CreditPref.low     => "CREDIT_PREFERENCE LOW",
    CreditPref.neutral => "CREDIT_PREFERENCE NEUTRAL",
    CreditPref.high    => "CREDIT_PREFERENCE HIGH",
  };
  final leave   = "LEAVE_SLIDE ${appState.leaveDeltaDays >= 0 ? "+" : ""}${appState.leaveDeltaDays}";
  final reserve = "PREFER_RESERVE ${appState.preferReserve ? "ON" : "OFF"}";
  final bank    = "BANK_PROTECTION ${appState.bankProtection ? "ON" : "OFF"}";

  final lines = <String>[credit, leave, reserve, bank];

  // Track duplicates across all rows
  final seen = <String>{...lines.map((s) => s.toUpperCase())};

  for (final g in appState.groups) {
    // Visible boundary/comment for readability
    lines.add("; ${g.name}");
    for (final r in g.rows) {
      final t = r.text.trim();
      if (t.isEmpty) continue;
      final u = t.toUpperCase();

      // Strip any BANK_PROTECTION typed in groups; toggle rules above win
      if (_isBankLine(u)) continue;

      // De-dupe rows across all groups (keep first instance)
      if (seen.contains(u)) continue;

      // Keep if valid (else skip silently here; validation will surface it)
      if (_rowRe.hasMatch(u)) {
        lines.add(u);
        seen.add(u);
      }
    }
  }
  return lines;
}

/// Compose full text with CRLF (Windows/JSS friendly).
String composeJssText({bool windowsEol = true}) {
  final eol = windowsEol ? "\r\n" : "\n";
  return composeJssLines().join(eol) + eol;
}
