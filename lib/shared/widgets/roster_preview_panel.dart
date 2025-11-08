import 'package:flutter/material.dart';
import 'package:nextbid_demo/shared/services/app_state.dart';

class RosterPreviewPanel extends StatelessWidget {
  const RosterPreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final lines =
            appState.groups
                .expand((g) => g.rows)
                .map((r) => r.text.trim().toUpperCase())
                .where((s) => s.isNotEmpty)
                .toList();

        int award = 0, avoid = 0, set = 0, waive = 0;
        final trips = <String>{};
        for (final line in lines) {
          final parts = line.split(RegExp(r'\s+'));
          if (parts.isEmpty) continue;
          final cmd = parts.first;
          switch (cmd) {
            case 'AWARD':
              award++;
              if (parts.length > 1) trips.add(parts[1]);
              break;
            case 'AVOID':
              avoid++;
              if (parts.length > 1) trips.add(parts[1]);
              break;
            case 'SET':
              set++;
              break;
            case 'WAIVE':
              waive++;
              break;
          }
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview (Beta)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill('AWARD', award),
                    _pill('AVOID', avoid),
                    _pill('SET', set),
                    _pill('WAIVE', waive),
                  ],
                ),
                const SizedBox(height: 12),
                if (trips.isNotEmpty) ...[
                  const Text('Trips targeted'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: trips.map((t) => Chip(label: Text(t))).toList(),
                  ),
                ] else
                  const Text('Add bid commands to see a preview.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pill(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $count',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
