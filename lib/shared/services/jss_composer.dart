import "package:nextbid_demo/shared/spec/jss_spec.dart";
import "package:nextbid_demo/shared/services/app_state.dart";

/// Allowed row grammar: Aâ€“Z, 0â€“9, space, _ + - . , / : ( ) # = and backslash
final RegExp _rowRe = RegExp(r'^[A-Z0-9 _+\-.,/:()#=\\]{1,80}$');

class BidValidation {
  final int groups;
  final int rows;
  final List<String> errors;
  const BidValidation(this.groups, this.rows, this.errors);
  bool get ok => errors.isEmpty;
}

/// Validate current in-memory bid (uses [appState]).
BidValidation validateBid() {
  final errors = <String>[];

  // Hard limits
  if (appState.groups.length > JssSpec.maxGroups) {
    errors.add("Too many groups (max ${JssSpec.maxGroups}).");
  }
  final totalRows = appState.totalRows;
  if (totalRows > JssSpec.maxRows) {
    errors.add("Too many rows across groups (max ${JssSpec.maxRows}).");
  }

  // Validate each row + global de-dupe
  final seen = <String>{};
  for (var gi = 0; gi < appState.groups.length; gi++) {
    final g = appState.groups[gi];
    for (var ri = 0; ri < g.rows.length; ri++) {
      final t = g.rows[ri].text.trim().toUpperCase();
      if (t.isEmpty) continue;
      if (!_rowRe.hasMatch(t)) {
        errors.add("Invalid row in ${g.name} #${ri + 1}: '$t'");
      } else if (seen.contains(t)) {
        errors.add("Duplicate row (will be de-duped on export): '$t'");
      } else {
        seen.add(t);
      }
    }
  }

  // Build a simple groups structure of row lines for bank-protection rule
  final groups = <List<String>>[];
  for (final g in appState.groups) {
    final lines = <String>[];
    for (final r in g.rows) {
      final u = r.text.trim().toUpperCase();
      if (u.isNotEmpty) lines.add(u);
    }
    groups.add(lines);
  }
  _checkBankProtectionRule(groups, errors);

  return BidValidation(appState.groups.length, totalRows, errors);
}

/// Compose to JSS lines: globals first, then groups (with de-dupe across all lines).
List<String> composeJssLines() {
  // Global directives
  final credit = switch (appState.creditPref) {
    CreditPref.low => "CREDIT_PREFERENCE LOW",
    CreditPref.neutral => "CREDIT_PREFERENCE NEUTRAL",
    CreditPref.high => "CREDIT_PREFERENCE HIGH",
  };
  final lines = <String>[credit];

  if (appState.useLeaveSlide) {
    final sign = appState.leaveDeltaDays >= 0 ? "+" : "";
    lines.add("LEAVE_SLIDE $sign${appState.leaveDeltaDays}");
  }

  lines.add("PREFER_RESERVE ${appState.preferReserve ? "ON" : "OFF"}");

  // De-duplication across everything
  final seen = <String>{...lines.map((s) => s.toUpperCase())};

  for (final g in appState.groups) {
    lines.add("; ${g.name}");
    for (final r in g.rows) {
      final t = r.text.trim();
      if (t.isEmpty) continue;
      final u = t.toUpperCase();
      if (_rowRe.hasMatch(u) && !seen.contains(u)) {
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

// -------- Bank protection helper (used inside validateBid) --------

bool _isBankProtection(String line) {
  final up = line.trim().toUpperCase();
  return up.startsWith(JssSpec.bankProtectionPrefix) &&
      up.contains(" ${JssSpec.bankProtectionPool}");
}

/// Bank protection (if present) must be the FIRST line of the FINAL group.
void _checkBankProtectionRule(List<List<String>> groups, List<String> errors) {
  // Collect occurrences
  final hits = <Map<String, int>>[];
  for (var gi = 0; gi < groups.length; gi++) {
    final g = groups[gi];
    for (var ri = 0; ri < g.length; ri++) {
      if (_isBankProtection(g[ri])) {
        hits.add({"g": gi, "r": ri});
      }
    }
  }
  if (hits.isEmpty) return; // optional command

  if (hits.length > 1) {
    errors.add(
      "Bank protection must appear only once (final group, first line).",
    );
    return;
  }
  final gi = hits.first["g"]!;
  final ri = hits.first["r"]!;
  if (gi != groups.length - 1 || ri != 0) {
    errors.add(
      "Bank protection must be the FIRST line of your FINAL bid group.",
    );
  }
}
