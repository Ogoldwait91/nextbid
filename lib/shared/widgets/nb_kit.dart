import "package:flutter/material.dart";

class NbCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const NbCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: padding, child: child));
  }
}

class NbPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const NbPrimaryButton({super.key, required this.label, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
