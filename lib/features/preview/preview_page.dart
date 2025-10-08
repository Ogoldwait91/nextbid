import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
            FilledButton.icon(onPressed: () => _copy(context), icon: const Icon(Icons.copy), label: const Text("Copy")),
          ],
        ),
      ),
    );
  }
}
