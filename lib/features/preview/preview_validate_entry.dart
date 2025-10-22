import "package:flutter/material.dart";
import "package:nextbid_demo/shared/services/validate_client.dart";
import "package:nextbid_demo/shared/widgets/validate_banner.dart";

void main() => runApp(const PreviewValidateApp());

class PreviewValidateApp extends StatelessWidget {
  const PreviewValidateApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreviewValidatePage(),
    );
  }
}

class PreviewValidatePage extends StatefulWidget {
  const PreviewValidatePage({super.key});
  @override
  State<PreviewValidatePage> createState() => _PreviewValidatePageState();
}

class _PreviewValidatePageState extends State<PreviewValidatePage> {
  final _controller = TextEditingController(text: "!GROUP 1\r\n SET CREDIT 500-540\r\n WAIVE LONGHAUL\r\n!END GROUP\r\n");
  Map<String, dynamic>? _validateResult;
  bool _busy = false;

  Future<void> _validate() async {
    setState(() => _busy = true);
    try {
      const base = String.fromEnvironment("NEXTBID_API", defaultValue: "http://127.0.0.1:8000");
      final api = ApiClient(base);
      final res = await api.validateBid(_controller.text);
      setState(() => _validateResult = res);
      final ok = (res["ok"] as bool?) ?? false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? "Validation OK" : "Validation issues found")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Validate failed: $e")));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = _validateResult;
    return Scaffold(
      appBar: AppBar(title: const Text("Preview + Validate")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "JSS text",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _busy ? null : _validate,
                  icon: const Icon(Icons.rule),
                  label: const Text("Validate"),
                ),
                const SizedBox(width: 12),
                if (_busy) const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            const SizedBox(height: 12),
            if (res != null)
              ValidateBanner(
                errors: (res["errors"] as List?) ?? const [],
                warnings: (res["warnings"] as List?) ?? const [],
              ),
          ],
        ),
      ),
    );
  }
}
