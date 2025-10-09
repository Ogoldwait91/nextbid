import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/app_state.dart";
import "../../shared/services/api_client.dart";
import "../../shared/widgets/credit_range_selector.dart";
import "../../shared/widgets/leave_slide_visualizer.dart";
import "../../shared/widgets/reserve_selector.dart";
import "../../shared/widgets/logout_leading.dart";
import "../../shared/widgets/pairings_overview.dart";

class PreProcessPage extends StatefulWidget {
  const PreProcessPage({super.key});
  @override State<PreProcessPage> createState() => _PreProcessPageState();
}

class _PreProcessPageState extends State<PreProcessPage> {
  final _api = const ApiClient();
  static const String _month = "2025-11";

  bool _loadingCredit = true;
  String? _creditErr;

  bool _loadingCalendar = true;
  String? _calendarErr;
  List<Map<String, dynamic>> _stages = const [];

  bool _loadingPairings = true;
  String? _pairingsErr;
  List<Map<String, dynamic>> _pairings = const [];
  double _avgCredit = 0.0;

  late CreditPref _credit = appState.creditPref;
  late bool _useLeave = appState.useLeaveSlide;
  late int _leave = appState.leaveDeltaDays;
  late bool _reserve = appState.preferReserve;

  @override
  void initState() {
    super.initState();
    _fetchCredit();
    _fetchCalendar();
    _fetchPairings();
  }

  // --- API fetches ---
  Future<void> _fetchCredit() async {
    setState(() { _loadingCredit = true; _creditErr = null; });
    try {
      final data = await _api.credit(_month);
      final min = (data["min"] as num).toInt();
      final max = (data["max"] as num).toInt();
      final def = (data["default"] as num).toInt();
      appState.setCreditRanges(min: min, max: max, def: def);
    } catch (e) {
      _creditErr = e.toString();
    } finally {
      if (mounted) setState(() => _loadingCredit = false);
    }
  }

  Future<void> _fetchCalendar() async {
    setState(() { _loadingCalendar = true; _calendarErr = null; });
    try {
      final data = await _api.calendar(_month);
      final list = (data["stages"] as List).cast<Map<String, dynamic>>();
      _stages = list;
    } catch (e) {
      _calendarErr = e.toString();
    } finally {
      if (mounted) setState(() => _loadingCalendar = false);
    }
  }

  Future<void> _fetchPairings() async {
    setState(() { _loadingPairings = true; _pairingsErr = null; });
    try {
      final data = await _api.pairings(_month);
      final list = (data["pairings"] as List).cast<Map<String, dynamic>>();
      _pairings = list;
      final stats = data["stats"] as Map<String, dynamic>? ?? {};
      _avgCredit = (stats["avg_credit"] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      _pairingsErr = e.toString();
    } finally {
      if (mounted) setState(() => _loadingPairings = false);
    }
  }

  // --- local state sync ---
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

  // --- UI helpers (stage dates) ---
  String _monthLabel(String ym) {
    final parts = ym.split("-");
    if (parts.length != 2) return ym;
    final year = parts[0];
    final m = int.tryParse(parts[1]) ?? 1;
    const names = ["January","February","March","April","May","June","July","August","September","October","November","December"];
    return "${names[(m-1).clamp(0, 11)]} $year";
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    const m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${dt.day} ${m[dt.month-1]}";
  }

  Widget _stageDatesCard() {
    if (_loadingCalendar) {
      return const Card(child: ListTile(title: Text("Stage dates"), trailing: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())));
    }
    if (_calendarErr != null) {
      return Card(
        child: ListTile(
          title: const Text("Stage dates"),
          subtitle: Text("Failed to load: $_calendarErr"),
          trailing: OutlinedButton(onPressed: _fetchCalendar, child: const Text("Retry")),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Stage dates • ${_monthLabel(_month)}", style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (_stages.isEmpty) const Text("No stages available"),
          ..._stages.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.event_note, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text("${s["name"]}")),
                Text(_formatDate("${s["date"]}")),
              ],
            ),
          )),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // keep the original credit fetch gate simple
    if (_loadingCredit) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_creditErr != null) {
      return Scaffold(
        appBar: AppBar(leading: const LogoutLeading(), title: const Text("Pre-Process")),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Failed to load credit ranges:\n$_creditErr"),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _fetchCredit, child: const Text("Retry")),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const LogoutLeading(),
        title: const Text("Pre-Process"),
        actions: [
          IconButton(tooltip: "Refresh data", onPressed: () { _fetchCredit(); _fetchCalendar(); _fetchPairings(); }, icon: const Icon(Icons.cloud_sync_outlined)),
          IconButton(tooltip: "Reset", onPressed: () {
            setState(() {
              _credit = CreditPref.neutral;
              _useLeave = false;
              _leave = 0;
              _reserve = false;
            });
            _syncState();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset to defaults")));
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _stageDatesCard(),
          const SizedBox(height: 8),

          // Pairings overview (loading/error states inline)
          if (_loadingPairings)
            const Card(child: ListTile(title: Text("Pairings overview"), trailing: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())))
          else if (_pairingsErr != null)
            Card(
              child: ListTile(
                title: const Text("Pairings overview"),
                subtitle: Text("Failed to load: $_pairingsErr"),
                trailing: OutlinedButton(onPressed: _fetchPairings, child: const Text("Retry")),
              ),
            )
          else
            PairingsOverview(pairings: _pairings, avgCredit: _avgCredit),

          const SizedBox(height: 8),
          CreditRangeSelector(
            value: _credit,
            onChanged: (v) => setState(() { _credit = v; _syncState(); }),
            min: appState.creditMin,
            max: appState.creditMax,
            def: appState.creditDefault,
          ),

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
          ReserveSelector(
            value: _reserve,
            onChanged: (v) => setState(() { _reserve = v; _syncState(); }),
          ),
          const SizedBox(height: 8),
          _SummaryCard(credit: _credit, useLeave: _useLeave, leave: _leave, reserve: _reserve),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.check), label: const Text("Submit")),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CreditPref credit; final bool useLeave; final int leave; final bool reserve;
  const _SummaryCard({required this.credit, required this.useLeave, required this.leave, required this.reserve});
  String get _creditLabel => switch (credit) { CreditPref.low => "Low", CreditPref.neutral => "Neutral", CreditPref.high => "High" };
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
    title: const Text("Summary"),
    subtitle: Text("Credit: $_creditLabel • Leave: ${useLeave ? (leave >= 0 ? "+" : "") + leave.toString() : "Off"} • Reserve: ${reserve ? "Yes" : "No"}"),
  ));
}
