import "package:flutter/material.dart";
import "../services/app_state.dart";

class CreditRangeSelector extends StatelessWidget {
  final CreditPref value;
  final ValueChanged<CreditPref> onChanged;
  const CreditRangeSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Credit Preference"),
            const SizedBox(height: 8),
            SegmentedButton<CreditPref>(
              segments: const [
                ButtonSegment(value: CreditPref.low, icon: Icon(Icons.trending_down), label: Text("Low")),
                ButtonSegment(value: CreditPref.neutral, icon: Icon(Icons.drag_handle), label: Text("Neutral")),
                ButtonSegment(value: CreditPref.high, icon: Icon(Icons.trending_up), label: Text("High")),
              ],
              selected: {value},
              onSelectionChanged: (set) => onChanged(set.first),
            ),
          ],
        ),
      ),
    );
  }
}
