import "package:flutter/material.dart";

class LeaveSlideVisualizer extends StatelessWidget {
  final int value; // -3..+3
  final ValueChanged<int> onChanged;
  final bool enabled;
  const LeaveSlideVisualizer({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final slider = Slider(
      min: -3,
      max: 3,
      divisions: 6,
      label: value.toString(),
      value: value.toDouble(),
      onChanged: enabled ? (d) => onChanged(d.round()) : null,
    );

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
                Expanded(child: slider),
                const Text("+3"),
              ],
            ),
            Text(
              enabled
                  ? "Selected: ${value >= 0 ? "+" : ""}$value day(s)"
                  : "Leave slide is OFF",
              style: TextStyle(color: enabled ? null : Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
