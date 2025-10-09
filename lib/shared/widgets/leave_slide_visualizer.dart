import "package:flutter/material.dart";

class LeaveSlideVisualizer extends StatelessWidget {
  final int value; // -3..+3
  final ValueChanged<int> onChanged;
  const LeaveSlideVisualizer({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leave Slide (days)"),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("-3"),
                Expanded(
                  child: Slider(
                    min: -3, max: 3, divisions: 6,
                    label: value.toString(),
                    value: value.toDouble(),
                    onChanged: (d) => onChanged(d.round()),
                  ),
                ),
                const Text("+3"),
              ],
            ),
            Text("Selected: ${value >= 0 ? "+" : ""}$value day(s)"),
          ],
        ),
      ),
    );
  }
}
