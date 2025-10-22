import "package:flutter/material.dart";
import "package:nextbid_demo/shared/services/validate_client.dart";
import "package:nextbid_demo/shared/widgets/validate_banner.dart";

/// Provide either [controller] or [getText]. If both provided, [getText] wins.
class ValidateSection extends StatefulWidget {
  final TextEditingController? controller;
  final String Function()? getText;
  const ValidateSection({super.key, this.controller, this.getText});

  @override
  State<ValidateSection> createState() => _ValidateSectionState();
}

class _ValidateSectionState extends State<ValidateSection> {
  Map<String, dynamic>? _validateResult;
  bool _busy = false;

  String _currentText() {
    if (widget.getText != null) return widget.getText!.call();
    return widget.controller?.text ?? "";
  }

  Future<void> _validate() async {
    setState(() => _busy = true);
    try {
      const base = String.fromEnvironment(
        "NEXTBID_API",
        defaultValue: "http://127.0.0.1:8000",
      );
      final api = ApiClient(base);
      final res = await api.validateBid(_currentText());
      setState(() => _validateResult = res);
      final ok = (res["ok"] as bool?) ?? false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? "Validation OK" : "Validation issues found"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Validate failed: $e")));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _busy ? null : _validate,
          icon: const Icon(Icons.rule),
          label: const Text("Validate"),
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (_validateResult != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ValidateBanner(
              errors: (_validateResult!["errors"] as List?) ?? const [],
              warnings: (_validateResult!["warnings"] as List?) ?? const [],
            ),
          ),
      ],
    );
  }
}
