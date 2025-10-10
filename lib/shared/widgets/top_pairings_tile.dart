import "package:flutter/material.dart";
import "../services/api_client.dart";

class TopPairingsTile extends StatelessWidget {
  final String month;
  const TopPairingsTile({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final api = const ApiClient();
    return FutureBuilder<Map<String, dynamic>>(
      future: api.fetchPairings(month, limit: 3),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: LinearProgressIndicator(),
            ),
          );
        }
        if (snap.hasError) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text("Couldn’t load pairings."),
            ),
          );
        }
        final data = snap.data ?? const {};
        final items = (data["pairings"] as List?) ?? const [];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Top 3 Pairings",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                for (final p in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p["id"]?.toString() ?? "—"),
                        Text(
                          "${p["type"] ?? ""} • ${p["region"] ?? ""} • ${p["credit"] ?? "?"}h",
                        ),
                      ],
                    ),
                  ),
                if (items.isEmpty) const Text("No pairings."),
              ],
            ),
          ),
        );
      },
    );
  }
}
