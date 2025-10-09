import 'dart:convert';
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/auth_state.dart";
import "../../shared/services/profile_state.dart";
import "../../shared/services/privacy_state.dart";
import "../../shared/widgets/logout_leading.dart";
import "../../shared/widgets/faq_accordion.dart";
import "../../shared/utils/input_formatters.dart";
import "../../shared/services/api_client.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _api = const ApiClient();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _rankCtrl;
  late final TextEditingController _crewCtrl;
  late final TextEditingController _staffCtrl;

  bool _busy = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: profileState.name);
    _rankCtrl = TextEditingController(text: profileState.rank);
    _crewCtrl = TextEditingController(text: profileState.crewCode);
    _staffCtrl = TextEditingController(text: profileState.staffNo);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rankCtrl.dispose();
    _crewCtrl.dispose();
    _staffCtrl.dispose();
    super.dispose();
  }

  void _save() {
    profileState.update(
      name: _nameCtrl.text.trim(),
      rank: _rankCtrl.text.trim(),
      crewCode: _crewCtrl.text.trim(),
      staffNo: _staffCtrl.text.trim(),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile updated")));
  }

  Future<void> _downloadMyData() async {
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final data = await _api.privacyDownload();
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text("Your data (stub)"),
              content: SingleChildScrollView(child: Text((const JsonEncoder.withIndent('  ')).convert(data))),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteMyData() async {
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final res = await _api.privacyDelete();
      if (!mounted) return;
      final ok = res["ok"] == true;
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text(ok ? "Delete request sent" : "Delete failed"),
              content: Text(
                ok
                    ? "Your stored data has been deleted (stub)."
                    : res.toString(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText =
        (profileState.seniority != null && profileState.cohortSize != null)
            ? "Seniority: ${profileState.seniority} / ${profileState.cohortSize}"
            : "Not resolved yet";

    return Scaffold(
      appBar: AppBar(
        leading: const LogoutLeading(),
        title: const Text("Profile"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Personal details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _rankCtrl,
                    decoration: const InputDecoration(
                      labelText: "Rank (e.g., FO/Capt)",
                      prefixIcon: Icon(Icons.workspace_premium_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _crewCtrl,
                    maxLength: 8,
                    inputFormatters: [UpperCaseTextFormatter(), crewCodeFilter],
                    decoration: const InputDecoration(
                      labelText: "Crew code",
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _staffCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Staff number",
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _busy ? null : _save,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text("Save"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed:
                            _busy ? null : () async => await _downloadMyData(),
                        icon:
                            _busy
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.download_outlined),
                        label: const Text("Download my data"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed:
                            _busy ? null : () async => await _deleteMyData(),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Delete my data"),
                      ),
                    ],
                  ),
                  if (_err != null) ...[
                    const SizedBox(height: 8),
                    Text(_err!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.insights_outlined),
                    title: const Text("Status"),
                    subtitle: Text(statusText),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Privacy consent (unchanged)
          Card(
            child: SwitchListTile(
              title: const Text("Share anonymised insights"),
              subtitle: const Text("Enable cohort analytics (k-anon 25+)"),
              value: privacyConsent.value,
              onChanged: (v) => setState(() => privacyConsent.value = v),
              secondary: IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: "More info",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder:
                        (_) => const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Privacy & Cohort Insights",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 12),
                                FAQAccordion(
                                  items: [
                                    FAQItem(
                                      "What is anonymised cohort data?",
                                      "Aggregated stats across many pilots (minimum k-anonymity of 25). No personal roster data is shown.",
                                    ),
                                    FAQItem(
                                      "Why enable this?",
                                      "It unlocks anonymised demand signals (e.g., where the crowd is bidding) to help guide your own strategy.",
                                    ),
                                    FAQItem(
                                      "Can I download or delete my data?",
                                      "Yes. These options appear here. For now, they act on stubbed server data.",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: FilledButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Sign out"),
              onPressed: () {
                authState.value = false;
                context.go("/login");
              },
            ),
          ),
        ],
      ),
    );
  }
}



