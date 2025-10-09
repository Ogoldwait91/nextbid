import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "../../shared/services/jss_composer.dart";
import "../../shared/widgets/logout_leading.dart";

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  Future<void> _copy(BuildContext context) async {
    final text = composeJssText(windowsEol: true);
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Commands copied")));
    }
  }

  Future<void> _export(BuildContext context) async {
    final text = composeJssText(windowsEol: true);
    try {
      Directory? dir = await getDownloadsDirectory();
      dir ??= await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(":", "-");
      final file = File("${dir.path}${Platform.pathSeparator}nextbid_commands_$ts.txt");
      await file.writeAsString(text); // UTF-8 by default
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
    final lines = composeJssLines();
    return Scaffold(
      appBar: AppBar(leading: const LogoutLeading(), title: const Text("Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Align(alignment: Alignment.centerLeft, child: Text(lines.join("\n"), style: const TextStyle(fontFamily: "monospace"))))),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              FilledButton.icon(onPressed: () => _copy(context),   icon: const Icon(Icons.copy),              label: const Text("Copy")),
              OutlinedButton.icon(onPressed: () => _export(context), icon: const Icon(Icons.download_outlined), label: const Text("Export .txt")),
            ]),
          ],
        ),
      ),
    );
  }
}
