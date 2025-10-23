import "dart:io";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "package:nextbid_demo/shared/services/jss_composer.dart";
import 'package:nextbid_demo/shared/widgets/logout_leading.dart';
import 'package:nextbid_demo/shared/widgets/bid_group_editor.dart';
import 'package:nextbid_demo/shared/widgets/validation_banner.dart';
import 'package:nextbid_demo/shared/services/api_client.dart';
import 'package:nextbid_demo/shared/services/app_state.dart';

class BuildBidPage extends StatelessWidget {
  const BuildBidPage({super.key});

  Future<bool> _preflight(BuildContext context) async {
    final v = validateBid();
    if (v.ok) return true;
    await showDialog<void>(
      context: context,
      builder:
          (buildCtx) => AlertDialog(
            title: const Text("Cannot export yet"),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      v.errors
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ $e",
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(buildCtx).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
    );
    return false;
  }

  Future<void> _copy(BuildContext context) async {
    if (!(await _preflight(context))) return;
    final text = composeJssText();
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Commands copied")));
    }
  }

  Future<void> _export(BuildContext context) async {
    if (!(await _preflight(context))) return;
    final text = composeJssText();
    try {
      Directory? dir = await getDownloadsDirectory();
      dir ??= await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(":", "-");
      final file = File(
        "${dir.path}${Platform.pathSeparator}nextbid_commands_$ts.txt",
      );
      await file.writeAsString(text); // UTF-8 + CRLF already from composer
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Saved to ${file.path}")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Export failed: $e")));
      }
    }
  }

  Future<void> _serverCheck(BuildContext context) async {
    final api = const ApiClient();
    final text = composeJssText();
    try {
      final res = await api.validateBidServer(text);
      if (!context.mounted) return;
      final ok = res["ok"] == true;
      final List<String> errs =
          (res['errors'] as List?)
              ?.map((e) => e.toString())
              .toList(growable: false) ??
          const <String>[];
      await showDialog<void>(
        context: context,
        builder:
            (buildCtx) => AlertDialog(
              title: Text(
                ok ? "Server validation passed" : "Server found issues",
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child:
                      ok
                          ? const Text("Looks good! Export is safe.")
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                errs
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        child: Text(
                                          "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ $e",
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(buildCtx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder:
            (buildCtx) => AlertDialog(
              title: const Text("Server validation failed"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(buildCtx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _serverExport(BuildContext context) async {
    final api = const ApiClient();
    final text = composeJssText();
    try {
      final res = await api.exportBidServer(text);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder:
            (buildCtx) => AlertDialog(
              title: const Text("Server export complete"),
              content: Text(
                "Saved on server (stub)\nBytes: ${res["size"]}\nWhen: ${res["ts"]}",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(buildCtx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder:
            (buildCtx) => AlertDialog(
              title: const Text("Server export failed"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(buildCtx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = composeJssLines();
    return Scaffold(
      appBar: AppBar(
        leading: const LogoutLeading(),
        title: const Text("Build"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: AnimatedBuilder(
              animation: appState,
              builder:
                  (context, _) => SwitchListTile(
                    title: const Text("Protect Bank"),
                    subtitle: const Text(
                      "Neutral credit only; JCR may add TASS to reach CAP",
                    ),
                    value: appState.protectBank,
                    onChanged: (v) => appState.setProtectBank(v),
                  ),
            ),
          ),
          const SizedBox(height: 8),
          const ValidationBanner(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lines.join("\n"),
                  style: const TextStyle(fontFamily: "monospace"),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const BidGroupEditor(),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: () => _copy(context),
                icon: const Icon(Icons.copy),
                label: const Text("Copy"),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _export(context),
                icon: const Icon(Icons.download_outlined),
                label: const Text("Export .txt"),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _serverCheck(context),
                icon: const Icon(Icons.shield_outlined),
                label: const Text("Server check"),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _serverExport(context),
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text("Server export"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
