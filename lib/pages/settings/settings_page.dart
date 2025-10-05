import 'package:flutter/material.dart';
import 'package:nextbid_app/services/profile_store.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = true;
  UserProfile? _p;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await ProfileStore.load();
    setState(() {
      _p = saved;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final p = _p;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (p == null) ...[
          const Text('No profile saved yet.'),
        ] else ...[
          _kv('Name', p.name),
          _kv('Email', p.email),
          _kv('Fleet', p.fleet),
          _kv('Base', p.base),
          _kv('Rank', p.rank),
          if (p.staffNo != null && p.staffNo!.isNotEmpty)
            _kv('Staff No', p.staffNo!),
        ],
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: _load,
          child: const Text('Reload Profile'),
        ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(k, style: Theme.of(context).textTheme.labelLarge)),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
