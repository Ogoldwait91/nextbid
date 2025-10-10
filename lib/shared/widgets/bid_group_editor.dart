import "package:flutter/material.dart";
import "../services/app_state.dart";
import "package:nextbid_demo/shared/services/jss_composer.dart";
import "../utils/input_formatters.dart";

class BidGroupEditor extends StatelessWidget {
  const BidGroupEditor({super.key});

  Future<bool> _confirmDeleteGroup(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Delete group?"),
                content: Text("Are you sure you want to delete “$name”?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                  ),
                ],
              ),
        ) ??
        false;
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
                  label: "Groups",
                  value: appState.groups.length,
                  max: 15,
                  warn: appState.groups.length > 15,
                ),
                const SizedBox(width: 12),
                _Counter(
                  label: "Rows",
                  value: appState.totalRows,
                  max: 40,
                  warn: appState.totalRows > 40,
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed:
                      appState.groups.length >= 15 ? null : appState.addGroup,
                  icon: const Icon(Icons.add),
                  label: const Text("Add group"),
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
                                labelText: "Group name",
                              ),
                              onChanged: (s) => appState.renameGroup(gi, s),
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: "More",
                            onSelected: (v) async {
                              if (v == "dup") appState.duplicateGroup(gi);
                              if (v == "del" &&
                                  await _confirmDeleteGroup(context, g.name)) {
                                appState.removeGroup(gi);
                              }
                            },
                            itemBuilder:
                                (context) => const [
                                  PopupMenuItem(
                                    value: "dup",
                                    child: ListTile(
                                      leading: Icon(Icons.copy),
                                      title: Text("Duplicate"),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "del",
                                    child: ListTile(
                                      leading: Icon(Icons.delete_outline),
                                      title: Text("Delete"),
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
                                  textInputAction: TextInputAction.next,
                                  maxLength: 80,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                    jssRowFilter,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: "Row",
                                    helperText:
                                        "Allowed: A–Z 0–9 _ + - . , / : \\ (≤80)",
                                    counterText: "",
                                  ),
                                  onChanged:
                                      (s) => appState.updateRow(gi, ri, s),
                                ),
                              ),
                              IconButton(
                                tooltip: "Remove row",
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
                                  : () => appState.addRow(gi),
                          icon: const Icon(Icons.add),
                          label: const Text("Add row"),
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
                                "• $e",
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
        "$label: $value / $max",
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
