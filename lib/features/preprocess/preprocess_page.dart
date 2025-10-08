import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/app_state.dart";
import "../../shared/widgets/credit_range_selector.dart";
import "../../shared/widgets/leave_slide_visualizer.dart";
import "../../shared/widgets/reserve_selector.dart";
import "../../shared/widgets/bank_protection_toggle.dart";
import "../../shared/widgets/logout_leading.dart";

class PreProcessPage extends StatefulWidget {
  const PreProcessPage({super.key});
  @override State<PreProcessPage> createState() => _PreProcessPageState();
}

class _PreProcessPageState extends State<PreProcessPage> {
  late CreditPref _credit = appState.creditPref;
  late int _leave = appState.leaveDeltaDays;
  late bool _reserve = appState.preferReserve;
  late bool _bank = appState.bankProtection;

  void _syncState() {
    appState
      ..creditPref = _credit
      ..leaveDeltaDays = _leave
      ..preferReserve = _reserve
      ..bankProtection = _bank
      ..notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const LogoutLeading(), title: const Text("Pre-Process")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CreditRangeSelector(value: _credit, onChanged: (v) => setState(() { _credit = v; _syncState(); })),
          LeaveSlideVisualizer(value: _leave, onChanged: (v) => setState(() { _leave = v; _syncState(); })),
          ReserveSelector(value: _reserve, onChanged: (v) => setState(() { _reserve = v; _syncState(); })),
          BankProtectionToggle(value: _bank, onChanged: (v) => setState(() { _bank = v; _syncState(); })),
          const SizedBox(height: 8),
          _SummaryCard(credit: _credit, leave: _leave, reserve: _reserve, bank: _bank),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => context.go("/build"), icon: const Icon(Icons.arrow_forward), label: const Text("Continue to Build")),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CreditPref credit; final int leave; final bool reserve; final bool bank;
  const _SummaryCard({required this.credit, required this.leave, required this.reserve, required this.bank, super.key});
  String get _creditLabel => switch (credit) { CreditPref.low => "Low", CreditPref.neutral => "Neutral", CreditPref.high => "High" };
  @override Widget build(BuildContext context) => Card(child: ListTile(
    title: const Text("Summary"),
    subtitle: Text("Credit: $_creditLabel • Leave: ${leave >= 0 ? "+" : ""}$leave • Reserve: ${reserve ? "Yes" : "No"} • Bank Prot: ${bank ? "On" : "Off"}"),
  ));
}
