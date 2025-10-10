import "package:flutter/material.dart";
import "package:nextbid_demo/shared/services/jss_composer.dart";
import "../services/app_state.dart";

class ValidationBanner extends StatelessWidget {
  const ValidationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final v = validateBid();
        if (v.ok) {
          return Card(
            color: Colors.green.withAlpha(18),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text("All good"),
              subtitle: const Text("Within limits and syntax looks valid."),
            ),
          );
        }
        final preview = v.errors.take(3).toList();
        return Card(
          color: Colors.red.withAlpha(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Please fix these before export",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...preview.map(
                  (e) =>
                      Text("• $e", style: const TextStyle(color: Colors.red)),
                ),
                if (v.errors.length > preview.length) const SizedBox(height: 8),
                if (v.errors.length > preview.length)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _showAll(context, v.errors),
                      child: Text(
                        "View ${v.errors.length - preview.length} more…",
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showAll(BuildContext context, List<String> errors) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Validation issues"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    errors
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text("• $e"),
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }
}
