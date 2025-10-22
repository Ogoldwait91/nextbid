import "package:flutter/material.dart";

void showToast(BuildContext context, String message, {bool ok = true}) {
  final color = ok ? Colors.green : Colors.red;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
