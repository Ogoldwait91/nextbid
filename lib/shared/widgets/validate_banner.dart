import "package:flutter/material.dart";

class ValidateBanner extends StatelessWidget {
  final List<dynamic> errors;
  final List<dynamic> warnings;
  const ValidateBanner({super.key, required this.errors, required this.warnings});

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty && warnings.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errors.isNotEmpty)
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Errors", style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...errors.map((e) => Text("• $e", style: TextStyle(color: Colors.red.shade800))),
                ],
              ),
            ),
          ),
        if (warnings.isNotEmpty)
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Warnings", style: TextStyle(color: Colors.amber.shade800, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...warnings.map((w) => Text("• $w", style: TextStyle(color: Colors.amber.shade800))),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
