import 'package:flutter/material.dart';
import 'package:nextbid_demo/shared/services/app_state.dart';
import 'package:nextbid_demo/shared/services/jss_composer.dart';
import 'package:nextbid_demo/shared/utils/input_formatters.dart';

class BidGroupEditor extends StatelessWidget {
  const BidGroupEditor({super.key});

  Future<bool> _confirmDeleteGroup(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete group?'),
                content: Text('Are you sure you want to delete "$name"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  // CENTERED DIALOG to compose a valid JSS command line
  Future<void> _addRowGuided(BuildContext context, int groupIndex) async {
    String cmdType = 'AWARD';
    String waiveOption = 'INDUSTRIAL REST';
    String setOption = 'MAX WP LENGTH';
    String selectedBase = 'ANY';
    final Set<String> selectedDays = <String>{};

    final tripCtl = TextEditingController();
    final dateCtl = TextEditingController();
    final poolCtl = TextEditingController(text: 'L--');
    final limitCtl = TextEditingController();
    final valueCtl = TextEditingController();
    final fromTimeCtl = TextEditingController();
    final toTimeCtl = TextEditingController();

    String up(String s) => s.trim().toUpperCase();

    final String? result = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(dialogCtx).viewInsets.bottom,
                ),
                child: StatefulBuilder(
                  builder: (context, setSt) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Add Bid Command',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),

                          // Command type
                          DropdownButtonFormField<String>(
                            value: cmdType,
                            decoration: const InputDecoration(
                              labelText: 'Command Type',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'AWARD',
                                child: Text('AWARD'),
                              ),
                              DropdownMenuItem(
                                value: 'AVOID',
                                child: Text('AVOID'),
                              ),
                              DropdownMenuItem(
                                value: 'WAIVE',
                                child: Text('WAIVE'),
                              ),
                              DropdownMenuItem(
                                value: 'SET',
                                child: Text('SET'),
                              ),
                            ],
                            onChanged:
                                (v) => setSt(() {
                                  cmdType = v ?? 'AWARD';
                                }),
                          ),
                          const SizedBox(height: 12),

                          // WAIVE
                          if (cmdType == 'WAIVE') ...[
                            DropdownButtonFormField<String>(
                              value: waiveOption,
                              decoration: const InputDecoration(
                                labelText: 'Waive Option',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'INDUSTRIAL REST',
                                  child: Text('Industrial Rest'),
                                ),
                                DropdownMenuItem(
                                  value: 'EASA REST',
                                  child: Text('EASA Rest'),
                                ),
                                DropdownMenuItem(
                                  value: 'DFW',
                                  child: Text('Relax DFW'),
                                ),
                                DropdownMenuItem(
                                  value: 'FDO',
                                  child: Text('Relax FDO'),
                                ),
                                DropdownMenuItem(
                                  value: 'NA',
                                  child: Text('Relax NA'),
                                ),
                                DropdownMenuItem(
                                  value: 'PD1',
                                  child: Text('Relax PD1'),
                                ),
                                DropdownMenuItem(
                                  value: 'PD2',
                                  child: Text('Relax PD2'),
                                ),
                                DropdownMenuItem(
                                  value: 'WR',
                                  child: Text('Relax WR'),
                                ),
                              ],
                              onChanged:
                                  (v) => setSt(
                                    () => waiveOption = v ?? waiveOption,
                                  ),
                            ),
                          ]
                          // SET
                          else if (cmdType == 'SET') ...[
                            DropdownButtonFormField<String>(
                              value: setOption,
                              decoration: const InputDecoration(
                                labelText: 'Set Option',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'MAX WP LENGTH',
                                  child: Text('Max WP length (days)'),
                                ),
                                DropdownMenuItem(
                                  value: 'MAX WP COUNT',
                                  child: Text('Max WP count'),
                                ),
                                DropdownMenuItem(
                                  value: 'MIN DAYS OFF',
                                  child: Text('Min days off between WPs'),
                                ),
                                DropdownMenuItem(
                                  value: 'REPORT TIME',
                                  child: Text(
                                    'Working period report time (HHMM)',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'RELEASE TIME',
                                  child: Text(
                                    'Working period release time (HHMM)',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'MAX NIGHTS AWAY',
                                  child: Text('Max nights away'),
                                ),
                              ],
                              onChanged:
                                  (v) =>
                                      setSt(() => setOption = v ?? setOption),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: valueCtl,
                              decoration: InputDecoration(
                                labelText:
                                    setOption.contains('TIME')
                                        ? 'Value (HHMM)'
                                        : 'Value',
                                hintText:
                                    setOption.contains('TIME')
                                        ? '1300'
                                        : 'e.g. 4',
                              ),
                            ),
                          ]
                          // AWARD / AVOID
                          else ...[
                            TextFormField(
                              controller: tripCtl,
                              decoration: const InputDecoration(
                                labelText: 'Trip Property',
                                hintText: 'e.g. TI7L11-005',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: dateCtl,
                              decoration: const InputDecoration(
                                labelText: 'Date Range (optional)',
                                hintText: '06NOV-10NOV',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 4,
                              children: [
                                for (final day in [
                                  'MON',
                                  'TUE',
                                  'WED',
                                  'THU',
                                  'FRI',
                                  'SAT',
                                  'SUN',
                                ])
                                  FilterChip(
                                    label: Text(day),
                                    selected: selectedDays.contains(day),
                                    onSelected: (sel) {
                                      setSt(() {
                                        if (sel) {
                                          selectedDays.add(day);
                                        } else {
                                          selectedDays.remove(day);
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: fromTimeCtl,
                                    decoration: const InputDecoration(
                                      labelText: 'From (HHMM)',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: toTimeCtl,
                                    decoration: const InputDecoration(
                                      labelText: 'To (HHMM)',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: selectedBase,
                              decoration: const InputDecoration(
                                labelText: 'Report Airport',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'ANY',
                                  child: Text('Any'),
                                ),
                                DropdownMenuItem(
                                  value: 'LGW',
                                  child: Text('LGW'),
                                ),
                                DropdownMenuItem(
                                  value: 'LHR',
                                  child: Text('LHR'),
                                ),
                              ],
                              onChanged:
                                  (v) => setSt(() => selectedBase = v ?? 'ANY'),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value:
                                  (poolCtl.text.isNotEmpty
                                      ? poolCtl.text
                                      : 'L--'),
                              decoration: const InputDecoration(
                                labelText: 'Trip Pool (optional)',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'L--',
                                  child: Text('L--'),
                                ),
                                DropdownMenuItem(
                                  value: 'L-',
                                  child: Text('L-'),
                                ),
                                DropdownMenuItem(value: 'L', child: Text('L')),
                                DropdownMenuItem(
                                  value: '+/-',
                                  child: Text('+/-'),
                                ),
                                DropdownMenuItem(value: 'H', child: Text('H')),
                                DropdownMenuItem(
                                  value: 'H+',
                                  child: Text('H+'),
                                ),
                                DropdownMenuItem(
                                  value: 'H++',
                                  child: Text('H++'),
                                ),
                              ],
                              onChanged:
                                  (v) => setSt(() => poolCtl.text = v ?? ''),
                            ),
                            const SizedBox(height: 8),
                            if (cmdType == 'AWARD')
                              TextFormField(
                                controller: limitCtl,
                                decoration: const InputDecoration(
                                  labelText: 'Limit (optional)',
                                  hintText: 'e.g. 3',
                                ),
                              ),
                          ],

                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(dialogCtx).pop(),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: () {
                                  String rowText = '';
                                  if (cmdType == 'WAIVE') {
                                    rowText = 'WAIVE ${up(waiveOption)}';
                                  } else if (cmdType == 'SET') {
                                    final val = up(valueCtl.text);
                                    if (val.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please enter a value'),
                                        ),
                                      );
                                      return;
                                    }
                                    rowText = 'SET ${up(setOption)} $val';
                                  } else {
                                    final trip = up(tripCtl.text);
                                    if (trip.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please enter a trip property',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final date = up(dateCtl.text);
                                    final pool = up(poolCtl.text);
                                    final limit = up(limitCtl.text);
                                    final fromT = up(fromTimeCtl.text);
                                    final toT = up(toTimeCtl.text);
                                    final days =
                                        selectedDays.isEmpty
                                            ? ''
                                            : selectedDays.join(',');

                                    rowText = '$cmdType $trip';
                                    if (date.isNotEmpty) rowText += ' $date';
                                    if (days.isNotEmpty) rowText += ' $days';
                                    if (fromT.isNotEmpty && toT.isNotEmpty) {
                                      rowText += ' $fromT-$toT';
                                    }
                                    if (selectedBase != 'ANY') {
                                      rowText += ' $selectedBase';
                                    }
                                    if (pool.isNotEmpty) rowText += ' $pool';
                                    if (cmdType == 'AWARD' &&
                                        limit.isNotEmpty) {
                                      rowText += ' $limit';
                                    }
                                  }
                                  Navigator.of(dialogCtx).pop(rowText);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      appState.addRow(groupIndex);
      final newRowIndex = appState.groups[groupIndex].rows.length - 1;
      appState.updateRow(groupIndex, newRowIndex, result.trim().toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final v = validateBid();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _Counter(
                  label: 'Groups',
                  value: appState.groups.length,
                  max: 15,
                  warn: appState.groups.length > 15,
                ),
                const SizedBox(width: 12),
                _Counter(
                  label: 'Rows',
                  value: appState.totalRows,
                  max: 40,
                  warn: appState.totalRows > 40,
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed:
                      appState.groups.length >= 15 ? null : appState.addGroup,
                  icon: const Icon(Icons.add),
                  label: const Text('Add group'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(appState.groups.length, (gi) {
              final g = appState.groups[gi];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: g.name,
                              decoration: const InputDecoration(
                                labelText: 'Group name',
                              ),
                              onChanged: (s) => appState.renameGroup(gi, s),
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'More',
                            onSelected: (v) async {
                              if (v == 'dup') appState.duplicateGroup(gi);
                              if (v == 'del' &&
                                  await _confirmDeleteGroup(context, g.name)) {
                                appState.removeGroup(gi);
                              }
                            },
                            itemBuilder:
                                (context) => const [
                                  PopupMenuItem(
                                    value: 'dup',
                                    child: ListTile(
                                      leading: Icon(Icons.copy),
                                      title: Text('Duplicate'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'del',
                                    child: ListTile(
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(g.rows.length, (ri) {
                        final row = g.rows[ri];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: row.text,
                                  maxLength: 80,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                    jssRowFilter,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Row',
                                    helperText:
                                        'Allowed: A-Z 0-9 _ + - . , / : \\  (max 80)',
                                    counterText: '',
                                  ),
                                  onChanged:
                                      (s) => appState.updateRow(gi, ri, s),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove row',
                                onPressed: () => appState.removeRow(gi, ri),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        );
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed:
                              appState.totalRows >= 40
                                  ? null
                                  : () => _addRowGuided(context, gi),
                          icon: const Icon(Icons.add),
                          label: const Text('Add row'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (!v.ok) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.red.withAlpha(20),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        v.errors
                            .map(
                              (e) => Text(
                                '• $e',
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final bool warn;
  const _Counter({
    required this.label,
    required this.value,
    required this.max,
    this.warn = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = warn ? Colors.red : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$label: $value / $max',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
