import "package:flutter/material.dart";
import "package:nextbid_demo/shared/services/api_client.dart";

class DeadlinesTile extends StatelessWidget {
  final String month;
  const DeadlinesTile({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    final api = const ApiClient();
    final safeMonth = (month.isEmpty) ? "2025-11" : month;

    return FutureBuilder<Map<String, dynamic>>(
      future: api.calendar(safeMonth),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text("Loading deadlines…"),
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
                  Expanded(child: Text("Can’t load deadlines: ${snap.error}")),
                ],
              ),
            ),
          );
        }

        final data = snap.data ?? const {};
        final stages = (data["stages"] as List?) ?? const [];

        if (stages.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("No deadlines for $safeMonth"),
            ),
          );
        }

        return Card(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deadlines • $safeMonth", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                for (final s in stages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(s["name"]?.toString() ?? "—")),
                        Text(s["date"]?.toString() ?? "—"),
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
