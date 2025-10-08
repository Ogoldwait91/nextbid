import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreProcessPage extends StatefulWidget {
  const PreProcessPage({super.key});

  @override
  State<PreProcessPage> createState() => _PreProcessPageState();
}

class _PreProcessPageState extends State<PreProcessPage> {
  double _leaveAllowance = 0;
  RangeValues _credit = const RangeValues(60, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pre-Process")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text("Credit range"),
              subtitle: Text("${_credit.start.toStringAsFixed(0)} – ${_credit.end.toStringAsFixed(0)} hrs"),
            ),
            RangeSlider(
              min: 40, max: 120, divisions: 80,
              values: _credit,
              onChanged: (v) => setState(() => _credit = v),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("Leave tolerance"),
              subtitle: Text("${_leaveAllowance.toStringAsFixed(0)} days"),
            ),
            Slider(
              min: -5, max: 5, divisions: 10,
              value: _leaveAllowance,
              label: _leaveAllowance.toStringAsFixed(0),
              onChanged: (v) => setState(() => _leaveAllowance = v),
            ),
            const Spacer(),
            Row(
              children: [
                OutlinedButton(onPressed: () => context.go('/dashboard'), child: const Text("Back")),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.go('/build'),
                  child: const Text("Save & Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
