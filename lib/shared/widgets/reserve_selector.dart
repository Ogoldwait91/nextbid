import "package:flutter/material.dart";

class ReserveSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const ReserveSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text("Prefer Reserve"),
        subtitle: const Text("Favour reserve patterns where possible"),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
