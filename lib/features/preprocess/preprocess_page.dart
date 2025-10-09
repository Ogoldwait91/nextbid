import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/app_state.dart";
import "../../shared/widgets/credit_range_selector.dart";
import "../../shared/widgets/leave_slide_visualizer.dart";
import "../../shared/widgets/reserve_selector.dart";
import "../../shared/widgets/logout_leading.dart";

class PreProcessPage extends StatefulWidget {
  const PreProcessPage({super.key});
  @override State<PreProcessPage> createState() => _PreProcessPageState();
}

class _PreProcessPageState extends State<PreProcessPage> {
  late CreditPref _credit = appState.creditPref;
  late bool _useLeave = appState.useLeaveSlide;
  late int _leave = appState.leaveDeltaDays;
  late bool _reserve = appState.preferReserve;

  void _syncState() {
    appState.setCreditPref(_credit);
    appState.setUseLeaveSlide(_useLeave);
    appState.setLeaveDelta(_leave);
    appState.setPreferReserve(_reserve);
  }

  void _submit() {
    _syncState();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preferences saved")));
    context.go("/build");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LogoutLeading(),
        title: const Text("Pre-Process"),
        actions: [
          IconButton(
            tooltip: "Reset",
            onPressed: () {
              setState(() {
                _credit = CreditPref.neutral;
                _useLeave = false;
                _leave = 0;
                _reserve = false;
              });
              _syncState();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset to defaults")));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Credit with ranges
          CreditRangeSelector(
            value: _credit,
            onChanged: (v) => setState(() { _credit = v; _syncState(); }),
            min: appState.creditMin,
            max: appState.creditMax,
            def: appState.creditDefault,
          ),

          // Leave slide toggle
          Card(
            child: SwitchListTile(
              title: const Text("Use Leave Slide"),
              subtitle: const Text("Enable to apply a +/- day offset in export"),
              value: _useLeave,
              onChanged: (v) => setState(() { _useLeave = v; _syncState(); }),
            ),
          ),
          LeaveSlideVisualizer(
            value: _leave,
            enabled: _useLeave,
            onChanged: (v) => setState(() { _leave = v; _syncState(); }),
          ),

          // Reserve
          ReserveSelector(
            value: _reserve,
            onChanged: (v) => setState(() { _reserve = v; _syncState(); }),
          ),

          const SizedBox(height: 8),
          _SummaryCard(credit: _credit, useLeave: _useLeave, leave: _leave, reserve: _reserve),
          const SizedBox(height: 12),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CreditPref credit; final bool useLeave; final int leave; final bool reserve;
  const _SummaryCard({required this.credit, required this.useLeave, required this.leave, required this.reserve});

  String get _creditLabel => switch (credit) {
    CreditPref.low => "Low",
    CreditPref.neutral => "Neutral",
    CreditPref.high => "High",
  };

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: const Text("Summary"),
      subtitle: Text("Credit: $_creditLabel • Leave: ${useLeave ? (leave >= 0 ? "+" : "") + leave.toString() : "Off"} • Reserve: ${reserve ? "Yes" : "No"}"),
    ),
  );
}
