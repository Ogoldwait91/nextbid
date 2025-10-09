import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/app_state.dart";
import "../../shared/widgets/heatmap_grid.dart";
import "../../shared/widgets/layover_preference_list.dart";
import "../../shared/widgets/logout_leading.dart";
import "../../shared/widgets/profile_chip.dart";

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _forecastCity() {
    if (appState.creditPref == CreditPref.high) return "New York";
    if (appState.preferReserve) return "Los Angeles";
    if (appState.leaveDeltaDays > 0) return "Singapore";
    return "Dubai";
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
        leading: const LogoutLeading(),
        title: const ProfileChip(), // <- shows name / rank / crew code & avatar
        actions: [
          IconButton(
            onPressed: () => context.go("/profile"),
            icon: const Icon(Icons.edit),
          ),
        ],
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
                  Text(
                    "Trend Dashboard",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Heatmap",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  HeatmapGrid(values: heat),
                  const SizedBox(height: 16),
                  const Text(
                    "Top Layover Preferences",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                  Text(
                    "My Forecast",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Most Likely Outcome",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${_forecastCity()} (Week 2)",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Confidence 60%",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go("/build"),
                    child: const Text("Sceno"),
                  ),
                ],
              ),
            ),
          ),
          // (rest of your cards unchanged)…
        ],
      ),
    );
  }
}
