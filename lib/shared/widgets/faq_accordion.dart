import "package:flutter/material.dart";

class FAQItem {
  final String q;
  final String a;
  const FAQItem(this.q, this.a);
}

class FAQAccordion extends StatelessWidget {
  final List<FAQItem> items;
  const FAQAccordion({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final it = items[i];
        return Card(
          child: ExpansionTile(
            title: Text(
              it.q,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(it.a),
              ),
            ],
          ),
        );
      },
    );
  }
}
