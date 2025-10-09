import "package:flutter/material.dart";
import "../services/privacy_state.dart";

class AnonymisedInsightsTile extends StatelessWidget {
  const AnonymisedInsightsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: privacyConsent,
      builder: (context, on, _) {
        if (!on) {
          return Card(
            child: ListTile(
              title: const Text("Cohort Insights"),
              subtitle: const Text("Turn on privacy consent to enable anonymised cohort insights."),
              trailing: FilledButton(
                onPressed: () => privacyConsent.value = true,
                child: const Text("Enable"),
              ),
            ),
          );
        }
        // (Pretend k-anon >= 25 check passed)
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cohort Insights", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: const [
                    _Pill("k-anon 25+"),
                    _Pill("Bid crowd: LAX wk2"),
                    _Pill("NYS high demand"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final String text; const _Pill(this.text);
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: c.withAlpha(20), borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: c, fontWeight: FontWeight.w600)),
    );
  }
}
