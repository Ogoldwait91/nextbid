import "package:flutter/material.dart";

class PairingsOverview extends StatelessWidget {
  final List<Map<String, dynamic>> pairings;
  final double avgCredit;
  const PairingsOverview({
    super.key,
    required this.pairings,
    required this.avgCredit,
  });

  @override
  Widget build(BuildContext context) {
    final total = pairings.length;
    final regions = <String, int>{};
    for (final p in pairings) {
      final r = (p["region"] ?? "UNK").toString();
      regions[r] = (regions[r] ?? 0) + 1;
    }
    final topRegions =
        regions.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final show = pairings.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pairings overview",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "Count: $total ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ Avg credit: ${avgCredit.toStringAsFixed(1)}",
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: -6,
              children:
                  topRegions
                      .take(3)
                      .map(
                        (e) => Chip(
                          label: Text(
                            "${e.key} ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ ${e.value}",
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 8),
            if (show.isEmpty)
              const Text("No pairings available")
            else
              ...show.map((p) {
                final id = p["id"] ?? "PAIR";
                final cr = p["credit"] ?? "?";
                final ngt = p["nights"] ?? "?";
                final rg = p["region"] ?? "UNK";
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.flight_takeoff),
                  title: Text("$id"),
                  subtitle: Text(
                    "Credit $cr ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ $ngt night(s) ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ $rg",
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
