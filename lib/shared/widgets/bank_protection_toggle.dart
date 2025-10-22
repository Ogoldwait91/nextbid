import "package:flutter/material.dart";

class BankProtectionToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const BankProtectionToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text("Bank Holiday Protection"),
        subtitle: const Text("Try to protect bank holidays in bids"),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
