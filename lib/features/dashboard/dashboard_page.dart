import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            _SectionTitle('Quick Actions'),
            _QuickActionsRow(),
            SizedBox(height: 16),
            _SectionTitle('This Month'),
            _ThisMonthSummary(),
            SizedBox(height: 16),
            _SectionTitle('Recent Activity'),
            _RecentList(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _ActionCard(icon: Icons.tune, label: 'Pre-Process'),
        _ActionCard(icon: Icons.list_alt, label: 'Build Bid'),
        _ActionCard(icon: Icons.visibility, label: 'Preview'),
        _ActionCard(icon: Icons.cloud_upload_outlined, label: 'Upload'),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon; final String label;
  const _ActionCard({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 90,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                const SizedBox(height: 6),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThisMonthSummary extends StatelessWidget {
  const _ThisMonthSummary();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(title: 'Credits', value: '—')),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: 'Leaves', value: '—')),
        SizedBox(width: 12),
        Expanded(child: _StatCard(title: 'Satisfaction', value: '—')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title; final String value;
  const _StatCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ListTile(leading: Icon(Icons.description_outlined), title: Text('Imported: Example_BidInfo.pdf'), subtitle: Text('Just now')),
          Divider(height: 0),
          ListTile(leading: Icon(Icons.description_outlined), title: Text('Exported: JSS_Commands.txt'), subtitle: Text('Yesterday')),
        ],
      ),
    );
  }
}
