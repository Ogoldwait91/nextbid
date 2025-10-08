import "package:flutter/material.dart";

class LayoverPreference {
  final String city; final double percent; // 0..1
  const LayoverPreference(this.city, this.percent);
}

class LayoverPreferenceList extends StatelessWidget {
  final List<LayoverPreference> items;
  const LayoverPreferenceList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: items.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(e.city, style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: e.percent,
                    backgroundColor: const Color(0xFFE7EAF0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 36,
                child: Text("${(e.percent*100).round()}%", textAlign: TextAlign.right),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
