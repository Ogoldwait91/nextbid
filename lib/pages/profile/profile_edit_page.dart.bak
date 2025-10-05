import 'package:flutter/material.dart';
import 'package:nextbid_app/services/profile_store.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfile initial;
  const ProfileEditPage({super.key, UserProfile? initial})
      : initial = initial ?? const UserProfile();

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _fleet;
  late TextEditingController _base;
  late TextEditingController _rank;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.name);
    _email = TextEditingController(text: widget.initial.email);
    _fleet = TextEditingController(text: widget.initial.fleet);
    _base = TextEditingController(text: widget.initial.base);
    _rank = TextEditingController(text: widget.initial.rank);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _fleet.dispose();
    _base.dispose();
    _rank.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = UserProfile(
      name: _name.text.trim(),
      email: _email.text.trim(),
      fleet: _fleet.text.trim(),
      base: _base.text.trim(),
      rank: _rank.text.trim(),
    );
    await ProfileStore.save(updated);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile saved')));
      Navigator.of(context).pop<UserProfile>(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(
              controller: _fleet,
              decoration:
                  const InputDecoration(labelText: 'Fleet (e.g., A350)')),
          const SizedBox(height: 12),
          TextField(
              controller: _base,
              decoration: const InputDecoration(labelText: 'Base (e.g., LHR)')),
          const SizedBox(height: 12),
          TextField(
              controller: _rank,
              decoration:
                  const InputDecoration(labelText: 'Rank (e.g., FO/Capt)')),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
