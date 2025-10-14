import "package:flutter/material.dart";
import "package:nextbid_demo/shared/services/api_client.dart";

class TopPairingsTile extends StatelessWidget {
  final String month;
  final int limit;
  const TopPairingsTile({super.key, required this.month, this.limit = 6});

  @override
  Widget build(BuildContext context) {
    final api = const ApiClient();
    // Fallback for empty month inputs
    final safeMonth = (month.isEmpty) ? "2025-11" : month;

    return FutureBuilder<Map<String, dynamic>>(
      future: api.pairings(safeMonth, limit: limit),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text("Loading pairings…"),
                ],
              ),
            ),
          );
        }
        if (snap.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(child: Text("Can’t load pairings")),
                  TextButton(
                    onPressed: () {
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snap.data ?? const {};
        final items = (data["pairings"] as List?) ?? const [];

        if (items.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("No pairings found for $safeMonth"),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Pairings • $safeMonth",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final p in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(p["id"]?.toString() ?? "—")),
                        Text("${p["credit"] ?? "?"}h"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
