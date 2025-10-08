import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "../../shared/services/app_state.dart";

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  List<String> _commands() {
    final c = switch (appState.creditPref) {
      CreditPref.low => "CREDIT_PREFERENCE LOW",
      CreditPref.neutral => "CREDIT_PREFERENCE NEUTRAL",
      CreditPref.high => "CREDIT_PREFERENCE HIGH",
    };
    final l = "LEAVE_SLIDE ${appState.leaveDeltaDays >= 0 ? "+" : ""}${appState.leaveDeltaDays}";
    final r = "PREFER_RESERVE ${appState.preferReserve ? "ON" : "OFF"}";
    final b = "BANK_PROTECTION ${appState.bankProtection ? "ON" : "OFF"}";
    return [c, l, r, b];
  }

  Future<void> _copy(BuildContext context) async {
    final text = _commands().join("\n");
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Commands copied")));
    }
  }

  Future<void> _export(BuildContext context) async {
    final text = _commands().join("\n");
    Directory? dir;
    try {
      dir = await getDownloadsDirectory();
      dir ??= await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(":", "-");
      final file = File("${dir.path}${Platform.pathSeparator}nextbid_commands_$ts.txt");
      await file.writeAsString(text);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved to ${file.path}")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cmds = _commands();
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(cmds.join("\n"), style: const TextStyle(fontFamily: "monospace")),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(onPressed: () => _copy(context), icon: const Icon(Icons.copy), label: const Text("Copy")),
                const SizedBox(width: 8),
                OutlinedButton.icon(onPressed: () => _export(context), icon: const Icon(Icons.download_outlined), label: const Text("Export .txt")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
