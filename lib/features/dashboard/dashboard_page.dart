import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbid_demo/common/widgets/nb_heatmap.dart';
import 'package:nextbid_demo/app/state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    const layovers = [
      ['New York', 24], ['Los Angeles', 16], ['Singapore', 15], ['Dubai', 14],
    ];
    final heat = [
      [0,1,2,3,2,1,0],
      [0,0,1,2,3,1,0],
      [0,0,0,1,2,2,0],
      [0,0,1,2,2,1,0],
      [0,1,2,3,2,0,0],
      [0,0,0,1,2,1,0],
      [0,0,1,1,2,0,0],
    ];

    void logoutFn(BuildContext c) {
      AppState.instance.logout();
      c.go('/login');
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back (Log out)',
          onPressed: () => logoutFn(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => logoutFn(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _ActionChip(title: 'Pre-Process', icon: Icons.tune,      onTap: () => context.go('/pre-process')),
                const SizedBox(width: 12),
                _ActionChip(title: 'Build Bid',   icon: Icons.list_alt,  onTap: () => context.go('/build')),
                const SizedBox(width: 12),
                _ActionChip(title: 'Preview',     icon: Icons.visibility, onTap: () {}),
                const SizedBox(width: 12),
                _ActionChip(title: 'Export',      icon: Icons.outbox,    onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),

            _CardBlock(
              title: 'Trend Dashboard',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Heatmap', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  NBHeatmap(data: heat),
                  const SizedBox(height: 16),
                  Text('Top Layover Preferences', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...layovers.map((e) {
                    final name = e[0] as String;
                    final pct  = (e[1] as int).toDouble();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: cs.primary.withValues(alpha: .25)),
                            ),
                            child: Text(name, style: Theme.of(context).textTheme.labelMedium),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: pct/100,
                                minHeight: 8,
                                backgroundColor: cs.surfaceContainerHighest.withValues(alpha: .5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(width: 38, child: Text('${pct.toInt()}%')),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            _CardBlock(
              title: 'My Forecast',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text('Most Likely Outcome', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Text('New York (Week 2)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text('Confidence 60%'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(onPressed: () {}, child: const Text('Sceno')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBlock extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardBlock({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          child,
        ]),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

