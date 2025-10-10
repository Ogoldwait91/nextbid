import 'package:flutter/material.dart';

class NBHeatmap extends StatelessWidget {
  final List<List<int>> data; // 0..4 intensity
  const NBHeatmap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final cols = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Color cell(int v) {
      // BA gold-ish scale on surface; tweak to taste
      final base = const Color(0xFFC8A45D);
      if (v <= 0) return cs.surfaceContainerHighest.withValues(alpha: .25);
      return base.withValues(alpha: (.15 + .2 * v).clamp(0.0, 1.0));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // column headers
        Row(
          children: [
            const SizedBox(width: 36), // space for row labels
            ...cols.map(
              (c) => Expanded(
                child: Text(
                  c,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // grid
        Column(
          children: List.generate(7, (r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      days[r],
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  ...List.generate(
                    data[r].length,
                    (c) => Expanded(
                      child: Container(
                        height: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: cell(data[r][c]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
