import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "../../shared/services/jss_composer.dart";
import "../../shared/widgets/logout_leading.dart";
import "../../shared/widgets/bid_group_editor.dart";
import "../../shared/widgets/validation_banner.dart";

class BuildBidPage extends StatelessWidget {
  const BuildBidPage({super.key});

  bool _preflight(BuildContext context) {
    final v = validateBid();
    if (v.ok) return true;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cannot export yet"),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: v.errors.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("• $e"),
              )).toList(),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
    return false;
  }

  Future<void> _copy(BuildContext context) async {
    if (!_preflight(context)) return;
    final text = composeJssText(windowsEol: true);
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Commands copied")));
    }
  }

  Future<void> _export(BuildContext context) async {
    if (!_preflight(context)) return;
    final text = composeJssText(windowsEol: true);
    try {
      Directory? dir = await getDownloadsDirectory();
      dir ??= await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(":", "-");
      final file = File("${dir.path}${Platform.pathSeparator}nextbid_commands_$ts.txt");
      await file.writeAsString(text); // UTF-8 + CRLF already from composer
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
      appBar: AppBar(leading: const LogoutLeading(), title: const Text("Build")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ValidationBanner(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(alignment: Alignment.centerLeft, child: Text(lines.join("\n"), style: const TextStyle(fontFamily: "monospace"))),
            ),
          ),
          const SizedBox(height: 12),
          const BidGroupEditor(),
          const SizedBox(height: 80), // leave space for bottom bar
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))]),
          child: Row(
            children: [
              FilledButton.icon(onPressed: () => _copy(context),   icon: const Icon(Icons.copy),              label: const Text("Copy")),
              const SizedBox(width: 8),
              OutlinedButton.icon(onPressed: () => _export(context), icon: const Icon(Icons.download_outlined), label: const Text("Export .txt")),
            ],
          ),
        ),
      ),
    );
  }
}
