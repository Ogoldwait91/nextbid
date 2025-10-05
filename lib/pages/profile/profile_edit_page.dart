import "package:flutter/material.dart";
import "../../services/profile_store.dart";

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _rank;
  late final TextEditingController _fleet;
  late final TextEditingController _base;
  late final TextEditingController _seniority;
  late final TextEditingController _staffNo;
  late final TextEditingController _credit;
  late final TextEditingController _leaveDays;
  late final TextEditingController _avatarUrl;

  @override
  void initState() {
    super.initState();
    final p = ProfileStore.instance.current;
    _name = TextEditingController(text: p.name);
    _rank = TextEditingController(text: p.rank);
    _fleet = TextEditingController(text: p.fleet);
    _base = TextEditingController(text: p.base);
    _seniority = TextEditingController(text: p.seniority.toString());
    _staffNo = TextEditingController(text: p.staffNo ?? "");
    _credit = TextEditingController(text: (p.credit ?? 0).toString());
    _leaveDays = TextEditingController(text: (p.leaveDays ?? 0).toString());
    _avatarUrl = TextEditingController(text: p.avatarUrl ?? "");
  }

  @override
  void dispose() {
    _name.dispose();
    _rank.dispose();
    _fleet.dispose();
    _base.dispose();
    _seniority.dispose();
    _staffNo.dispose();
    _credit.dispose();
    _leaveDays.dispose();
    _avatarUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    int parseInt(String v, int fallback) => int.tryParse(v.trim()) ?? fallback;
    double? parseDouble(String v, double? fallback) =>
        v.trim().isEmpty ? fallback : (double.tryParse(v.trim()) ?? fallback);

    final current = ProfileStore.instance.current;
    final updated = current.copyWith(
      name: _name.text.trim(),
      rank: _rank.text.trim(),
      fleet: _fleet.text.trim(),
      base: _base.text.trim(),
      seniority: parseInt(_seniority.text, current.seniority),
      staffNo: _staffNo.text.trim().isEmpty ? null : _staffNo.text.trim(),
      credit: parseDouble(_credit.text, current.credit),
      leaveDays: parseInt(_leaveDays.text, current.leaveDays ?? 0),
      avatarUrl: _avatarUrl.text.trim().isEmpty ? null : _avatarUrl.text.trim(),
    );

    await ProfileStore.instance.save(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile saved")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile")),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Required" : null),
            const SizedBox(height: 12),
            TextFormField(
                controller: _rank,
                decoration: const InputDecoration(labelText: "Rank")),
            const SizedBox(height: 12),
            TextFormField(
                controller: _fleet,
                decoration: const InputDecoration(labelText: "Fleet")),
            const SizedBox(height: 12),
            TextFormField(
                controller: _base,
                decoration: const InputDecoration(labelText: "Base")),
            const SizedBox(height: 12),
            TextFormField(
                controller: _seniority,
                decoration: const InputDecoration(labelText: "Seniority #"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextFormField(
                controller: _staffNo,
                decoration: const InputDecoration(labelText: "Staff No")),
            const SizedBox(height: 12),
            TextFormField(
                controller: _credit,
                decoration: const InputDecoration(labelText: "Credit (h)"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 12),
            TextFormField(
                controller: _leaveDays,
                decoration: const InputDecoration(labelText: "Leave days"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextFormField(
                controller: _avatarUrl,
                decoration:
                    const InputDecoration(labelText: "Avatar URL (optional)")),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child:
                    FilledButton(onPressed: _save, child: const Text("Save"))),
          ],
        ),
      ),
    );
  }
}
