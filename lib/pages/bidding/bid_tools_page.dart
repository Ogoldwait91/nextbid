import 'package:flutter/material.dart';

class BidToolsPage extends StatelessWidget {
  const BidToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.rule_folder_outlined, size: 56),
          const SizedBox(height: 12),
          Text('Bid Tools (Phase 1)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Command builder, leave slider, and credit preferences coming here.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
