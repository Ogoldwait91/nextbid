import "package:flutter/material.dart";

/// ReserveBlocksCalendar
/// - Shows a month grid (Mon–Sun), highlights days for the selected reserve block.
/// - Lets user cycle through blocks via left/right arrows or chips.
/// Props:
///   month: "YYYY-MM" (e.g., "2025-11")
///   blocks: [{"code":"R1","days":[2,9,...]}, ...]
///   index: selected block index
///   onIndexChanged: callback when selection changes
class ReserveBlocksCalendar extends StatelessWidget {
  final String month;
  final List<Map<String, dynamic>> blocks;
  final int index;
  final ValueChanged<int> onIndexChanged;

  const ReserveBlocksCalendar({
    super.key,
    required this.month,
    required this.blocks,
    required this.index,
    required this.onIndexChanged,
  });

  DateTime _firstOfMonth(String ym) {
    final parts = ym.split("-");
    final y = int.tryParse(parts[0]) ?? DateTime.now().year;
    final m = int.tryParse(parts.length > 1 ? parts[1] : "") ?? DateTime.now().month;
    return DateTime(y, m, 1);
  }

  int _daysInMonth(DateTime d) {
    final firstNext = DateTime(d.year, d.month + 1, 1);
    return firstNext.subtract(const Duration(days: 1)).day;
  }

  /// Monday-first offset: how many blanks before day 1
  int _leadingOffsetMondayStart(DateTime first) {
    // Dart weekday: Mon=1 ... Sun=7; for Monday-first grid, offset = weekday-1
    return first.weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    final dt = _firstOfMonth(month);
    final totalDays = _daysInMonth(dt);
    final lead = _leadingOffsetMondayStart(dt);
    final cells = <int?>[];

    // Leading blanks
    for (var i = 0; i < lead; i++) { cells.add(null); }
    // 1..totalDays
    for (var d = 1; d <= totalDays; d++) { cells.add(d); }
    // Trailing blanks to complete 6 weeks (6x7=42)
    while (cells.length % 7 != 0) { cells.add(null); }
    while (cells.length < 42) { cells.add(null); }

    final theme = Theme.of(context);

    final codes = blocks.map((b) => (b["code"] ?? "R").toString()).toList();
    final inx = (index < 0 || index >= blocks.length) ? 0 : index;
    final selected = blocks.isEmpty ? {"days": const <int>[]} : blocks[inx];
    final Set<int> days = ((selected["days"] as List?) ?? const <int>[])
        .cast<num>().map((e) => e.toInt()).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with arrows + selected chip
          Row(
            children: [
              const Text("Reserve blocks", style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                tooltip: "Previous block",
                onPressed: blocks.isEmpty ? null : () {
                  final next = (inx - 1 + blocks.length) % blocks.length;
                  onIndexChanged(next);
                },
                icon: const Icon(Icons.chevron_left),
              ),
              if (blocks.isNotEmpty)
                Chip(label: Text("${codes[inx]}"), visualDensity: VisualDensity.compact),
              IconButton(
                tooltip: "Next block",
                onPressed: blocks.isEmpty ? null : () {
                  final next = (inx + 1) % blocks.length;
                  onIndexChanged(next);
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chips for quick jump
          if (blocks.isNotEmpty)
            Wrap(
              spacing: 8, runSpacing: -8,
              children: List<Widget>.generate(blocks.length, (i) {
                final sel = i == inx;
                return ChoiceChip(
                  label: Text(codes[i]),
                  selected: sel,
                  onSelected: (_) => onIndexChanged(i),
                );
              }),
            ),

          const SizedBox(height: 8),

          // Weekday header (Mon..Sun)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Dow("Mon"), _Dow("Tue"), _Dow("Wed"), _Dow("Thu"), _Dow("Fri"), _Dow("Sat"), _Dow("Sun"),
            ],
          ),
          const SizedBox(height: 6),

          // Month grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, i) {
              final day = cells[i];
              final isDay = day != null;
              final isMarked = isDay && days.contains(day);

              final bg = isMarked ? theme.colorScheme.primary.withOpacity(0.15) : theme.colorScheme.surface;
              final br = isMarked ? Border.all(color: theme.colorScheme.primary, width: 1.5) : Border.all(color: theme.dividerColor.withOpacity(0.3));
              final txtStyle = isMarked
                  ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)
                  : theme.textTheme.bodyMedium;

              return Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: br,
                ),
                alignment: Alignment.center,
                child: Text(isDay ? "$day" : "", style: txtStyle),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class _Dow extends StatelessWidget {
  final String label;
  const _Dow(this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
