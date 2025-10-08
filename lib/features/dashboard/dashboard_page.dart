import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/app_state.dart";
import "../../shared/widgets/heatmap_grid.dart";
import "../../shared/widgets/layover_preference_list.dart";

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _forecastCity() {
    // placeholder logic – tweak as you like
    if (appState.creditPref == CreditPref.high) return "New York";
    if (appState.preferReserve) return "Los Angeles";
    if (appState.leaveDeltaDays > 0) return "Singapore";
    return "Dubai";
    // later: replace with real data model
  }

  @override
  Widget build(BuildContext context) {
    final prefs = const [
      LayoverPreference("New York", 0.24),
      LayoverPreference("Los Angeles", 0.16),
      LayoverPreference("Singapore", 0.15),
      LayoverPreference("Dubai", 0.14),
    ];

    final heat = [
      [0.0, 0.1, 0.0, 0.2, 0.6, 0.8, 0.0],
      [0.0, 0.0, 0.2, 0.5, 0.7, 0.4, 0.0],
      [0.1, 0.0, 0.3, 0.6, 0.8, 0.3, 0.0],
      [0.0, 0.1, 0.2, 0.5, 0.6, 0.2, 0.0],
      [0.0, 0.0, 0.1, 0.4, 0.5, 0.2, 0.0],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("BidView"),
        actions: [IconButton(onPressed: () => context.go("/profile"), icon: const Icon(Icons.more_horiz))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trend Dashboard", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text("Heatmap", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  HeatmapGrid(values: heat),
                  const SizedBox(height: 16),
                  const Text("Top Layover Preferences", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  LayoverPreferenceList(items: prefs),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("My Forecast", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text("Most Likely Outcome", style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 6),
                        Text("${_forecastCity()} (Week 2)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text("Confidence 60%", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: () => context.go("/build"), child: const Text("Sceno")),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Community Chat", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  OutlinedButton(onPressed: () {}, child: const Text("View")),
                  const SizedBox(height: 12),
                  const _Tip("Tips for this month’s bid?"),
                  const SizedBox(height: 8),
                  const _ChatBubble("If you want weekend days, consider requesting midweek layovers for LAX."),
                  const SizedBox(height: 8),
                  const _ChatBubble("Lots of people chasing NYS – might be smarter to go for LAX (week 2)."),
                  const SizedBox(height: 8),
                  TextField(decoration: const InputDecoration(hintText: "Type a message…"), onSubmitted: (_) {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget { final String text; const _Tip(this.text); @override Widget build(BuildContext c)=>Text(text, style: const TextStyle(fontWeight: FontWeight.w600)); }
class _ChatBubble extends StatelessWidget { final String text; const _ChatBubble(this.text); @override Widget build(BuildContext c)=>Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF1F3F6), borderRadius: BorderRadius.circular(12)), child: Text(text)); }
