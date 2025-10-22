import "package:flutter/material.dart";
import "../services/api_client.dart";
import "../services/privacy_state.dart"; // your ValueNotifier<bool> privacyConsent
// if you prefer to pull currentMonth here

class AnonymisedInsightsTile extends StatefulWidget {
  final String month;
  const AnonymisedInsightsTile({super.key, required this.month});

  @override
  State<AnonymisedInsightsTile> createState() => _AnonymisedInsightsTileState();
}

class _AnonymisedInsightsTileState extends State<AnonymisedInsightsTile> {
  bool loading = false;
  String? error;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    privacyConsent.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    privacyConsent.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    if (!privacyConsent.value) {
      setState(() {
        data = null;
        error = null;
        loading = false;
      });
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final api = const ApiClient();
      final r = await api.getCohortCompetitiveness(widget.month);
      if (r["ok"] == true) {
        setState(() => data = r);
      } else {
        setState(() => error = r["reason"]?.toString() ?? "unknown");
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Anonymised Insights",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            if (!privacyConsent.value)
              const Text("Turn on consent in Profile to see cohort insights."),
            if (privacyConsent.value && loading)
              const LinearProgressIndicator(),
            if (privacyConsent.value && error != null)
              Text("Error: $error", style: const TextStyle(color: Colors.red)),
            if (privacyConsent.value && data != null)
              Text(
                "P20: ${data!["percentiles"]["p20"]} â€¢ "
                "P50: ${data!["percentiles"]["p50"]} â€¢ "
                "P80: ${data!["percentiles"]["p80"]} â€¢ "
                "n=${data!["bid_count"]}",
              ),
          ],
        ),
      ),
    );
  }
}
