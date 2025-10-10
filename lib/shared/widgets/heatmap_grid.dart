import "package:flutter/material.dart";

class HeatmapGrid extends StatelessWidget {
  final List<List<double>> values; // 7 columns (Mon..Sun) x N rows
  const HeatmapGrid({super.key, required this.values});

  Color _cellColor(BuildContext context, double v) {
    v = v.clamp(0.0, 1.0);
    return Color.lerp(Colors.amber.shade100, Colors.amber.shade700, v)!;
  }

  @override
  Widget build(BuildContext context) {
    const dayLabels = ["M", "T", "W", "T", "F", "S", "S"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children:
              dayLabels
                  .map(
                    (d) => Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 6),
        Column(
          children:
              values.map((row) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children:
                        row
                            .map(
                              (v) => Expanded(
                                child: Container(
                                  height: 18,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _cellColor(context, v),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
