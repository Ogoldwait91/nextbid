import "package:flutter/foundation.dart";

enum CreditPref { low, neutral, high }

class BidRow { String text; BidRow(this.text); }
class BidGroup {
  String name;
  final List<BidRow> rows;
  BidGroup({required this.name, List<BidRow>? rows}) : rows = rows ?? <BidRow>[];
}

class AppState extends ChangeNotifier {
  // Pre-Process
  CreditPref creditPref = CreditPref.neutral;
  int leaveDeltaDays = 0;
  bool preferReserve = false;
  bool bankProtection = false;

  // Bid composition
  final List<BidGroup> groups = [BidGroup(name: "Group 1")];

  // Counters
  int get totalRows => groups.fold(0, (a, g) => a + g.rows.length);
  bool get withinLimits => groups.length <= 15 && totalRows <= 40;

  // Mutators
  void setCreditPref(CreditPref v) { creditPref = v; notifyListeners(); }
  void setLeaveDelta(int v) { leaveDeltaDays = v; notifyListeners(); }
  void setPreferReserve(bool v) { preferReserve = v; notifyListeners(); }
  void setBankProtection(bool v) { bankProtection = v; notifyListeners(); }

  void addGroup() {
    if (groups.length >= 15) return;
    groups.add(BidGroup(name: "Group ${groups.length + 1}"));
    notifyListeners();
  }

  void removeGroup(int index) {
    if (index < 0 || index >= groups.length) return;
    groups.removeAt(index);
    notifyListeners();
  }

  void renameGroup(int index, String name) {
    if (index < 0 || index >= groups.length) return;
    groups[index].name = name;
    notifyListeners();
  }

  void addRow(int gi) {
    if (totalRows >= 40 || gi < 0 || gi >= groups.length) return;
    groups[gi].rows.add(BidRow(""));
    notifyListeners();
  }

  void updateRow(int gi, int ri, String text) {
    if (gi < 0 || gi >= groups.length) return;
    if (ri < 0 || ri >= groups[gi].rows.length) return;
    groups[gi].rows[ri].text = text;
    notifyListeners();
  }

  void removeRow(int gi, int ri) {
    if (gi < 0 || gi >= groups.length) return;
    if (ri < 0 || ri >= groups[gi].rows.length) return;
    groups[gi].rows.removeAt(ri);
    notifyListeners();
  }

  void duplicateGroup(int index) {
    if (index < 0 || index >= groups.length) return;
    if (groups.length >= 15) return;
    final src = groups[index];
    final copy = BidGroup(
      name: "${src.name} (copy)",
      rows: src.rows.map((r) => BidRow(r.text)).toList(),
    );
    groups.insert(index + 1, copy);
    notifyListeners();
  }
}

final appState = AppState();
