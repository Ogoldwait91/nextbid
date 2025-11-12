import "dart:async";
import "package:flutter/material.dart";

class UiFeedback {
  static void toast(BuildContext context, String msg) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Wraps a future with a modal progress spinner.
  /// Avoids use_build_context_synchronously by pre-capturing Navigator.
  static Future<T> withSpinner<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    // Pre-capture before any awaits
    final navigator = Navigator.of(context, rootNavigator: true);

    // Show immediately; we don't need the Future result of showDialog.
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final result = await task();
      return result;
    } finally {
      // Close the dialog even if task throws
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }
}
