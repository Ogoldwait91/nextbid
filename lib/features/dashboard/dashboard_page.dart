import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "package:nextbid_demo/shared/services/app_state.dart";
import "package:nextbid_demo/shared/ui/spacing.dart";

// Existing shared widgets you already have in the repo:
import "package:nextbid_demo/shared/widgets/logout_leading.dart";
import "package:nextbid_demo/shared/widgets/profile_chip.dart";
import "package:nextbid_demo/shared/widgets/heatmap_grid.dart";
import "package:nextbid_demo/shared/widgets/layover_preference_list.dart";
import "package:nextbid_demo/shared/widgets/anonymised_insights_tile.dart";
// import "package:nextbid_demo/shared/widgets/top_pairings_tile.dart";

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
    // demo data you already used elsewhere
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
        title: const ProfileChip(),
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
          // ---- Insights tiles (consent-aware + pairings) ----
          AnonymisedInsightsTile(month: appState.currentMonth),
          gap12,
          const SizedBox.shrink(),
          gap16,

          // ---- Trend card ----
          Card(
            elevation: 1,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trend Dashboard",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  gap12,
                  const Text(
                    "Heatmap",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  gap8,
                  HeatmapGrid(values: heat),
                  gap16,
                  const Text(
                    "Top Layover Preferences",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  gap8,
                  LayoverPreferenceList(items: prefs),
                ],
              ),
            ),
          ),

          gap16,

          // ---- Forecast card ----
          Card(
            elevation: 1,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "My Forecast",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  gap12,
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Most Likely Outcome",
                          style: TextStyle(color: Colors.black54),
                        ),
                        gap6,
                        Text(
                          "${_forecastCity()} (Week 2)",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        gap4,
                        const Text(
                          "Confidence 60%",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  gap12,
                  FilledButton(
                    onPressed: () => context.go("/build"),
                    child: const Text("Sceno"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
