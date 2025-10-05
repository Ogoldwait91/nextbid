import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../ui/ui_kit.dart';
import '../profile/profile_edit_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = _UserProfile(
      name: "Oliver \"Oli\" Goldwait",
      rank: "Senior First Officer",
      fleet: "B777",
      base: "LHR",
      seniority: 231,
      staffNo: "BA123456",
      credit: 54.7,
      leaveDays: 18,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _ProfileHeader(profile: profile),
        const SizedBox(height: 16),

        // Quick actions
        SectionCard(
          child: Row(
            children: [
              Expanded(
                  child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.tune),
                      label: const Text("Build Bid"))),
              const SizedBox(width: 12),
              Expanded(
                  child: FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.assignment),
                      label: const Text("View Roster"))),
              const SizedBox(width: 12),
              Expanded(
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.beach_access),
                      label: const Text("Leave Planner"))),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Trend Dashboard
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader("Trend Dashboard"),
              const SizedBox(height: 12),
              Text("Heatmap", style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              const Heatmap(weeks: [
                [0.0, 0.1, 0.0, 0.0, 0.6, 0.8, 0.3],
                [0.1, 0.0, 0.0, 0.2, 0.7, 1.0, 0.4],
                [0.0, 0.0, 0.3, 0.0, 0.4, 0.6, 0.2],
              ]),
              const SizedBox(height: 16),
              Text("Top Layover Preferences",
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              const _PreferenceRow(city: "New York", percent: 0.24),
              const SizedBox(height: 8),
              const _PreferenceRow(city: "Los Angeles", percent: 0.16),
              const SizedBox(height: 8),
              const _PreferenceRow(city: "Singapore", percent: 0.15),
              const SizedBox(height: 8),
              const _PreferenceRow(city: "Dubai", percent: 0.14),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Forecast
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader("My Forecast"),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Most Likely Outcome",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text("New York (Week 2)",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text("Confidence 60%",
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ChevronTile(
                title: "Community Chat",
                subtitle:
                    "Ask questions and share tips with other crew members",
                trailing: FilledButton.tonal(
                  onPressed: () {},
                  child: const Text("View"),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Sceno"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Small progress row like the mock's Ã¢â‚¬Å“Top Layover PreferencesÃ¢â‚¬Â
class _PreferenceRow extends StatelessWidget {
  final String city;
  final double percent; // 0..1
  const _PreferenceRow({required this.city, required this.percent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: Text(city,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor:
                  Theme.of(context).progressIndicatorTheme.linearTrackColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
            width: 36,
            child: Text("${(percent * 100).round()} %",
                textAlign: TextAlign.right)),
      ],
    );
  }
}

// --- Profile model & header ---

class _UserProfile {
  final String name;
  final String rank;
  final String fleet;
  final String base;
  final int seniority;
  final String? staffNo;
  final String? avatarUrl;
  final double? credit;
  final int? leaveDays;

  const _UserProfile({
    required this.name,
    required this.rank,
    this.avatarUrl,
    required this.fleet,
    required this.base,
    required this.seniority,
    this.staffNo,
    this.credit,
    this.leaveDays,
  });
}

class _ProfileHeader extends StatelessWidget {
  final _UserProfile profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 720;
            return narrow ? _vertical(context, cs) : _horizontal(context, cs);
          },
        ),
      ),
    );
  }

  Widget _horizontal(BuildContext context, ColorScheme cs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Avatar(profile: profile),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(profile.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                _OverflowMenu(profile: profile),
              ]),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(icon: Icons.workspace_premium, text: profile.rank),
                  _InfoChip(icon: Icons.flight, text: profile.fleet),
                  _InfoChip(icon: Icons.place, text: profile.base),
                  _InfoChip(
                      icon: Icons.leaderboard, text: "#${profile.seniority}"),
                ],
              ),
              if (profile.staffNo != null) ...[
                const SizedBox(height: 6),
                Text("Staff No: ${profile.staffNo}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profile.credit != null)
              _MetricTile(
                  icon: Icons.schedule,
                  label: "Credit",
                  value: "${profile.credit!.toStringAsFixed(1)}h"),
            const SizedBox(width: 12),
            if (profile.leaveDays != null)
              _MetricTile(
                  icon: Icons.beach_access,
                  label: "Leave",
                  value: "${profile.leaveDays}d"),
          ],
        ),
      ],
    );
  }

  Widget _vertical(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _Avatar(profile: profile),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(profile.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  _OverflowMenu(profile: profile),
                ]),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                        icon: Icons.workspace_premium, text: profile.rank),
                    _InfoChip(icon: Icons.flight, text: profile.fleet),
                    _InfoChip(icon: Icons.place, text: profile.base),
                    _InfoChip(
                        icon: Icons.leaderboard, text: "#${profile.seniority}"),
                  ],
                ),
                if (profile.staffNo != null) ...[
                  const SizedBox(height: 6),
                  Text("Staff No: ${profile.staffNo}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Row(
          children: [
            if (profile.credit != null)
              Expanded(
                  child: _MetricTile(
                      icon: Icons.schedule,
                      label: "Credit",
                      value: "${profile.credit!.toStringAsFixed(1)}h")),
            if (profile.leaveDays != null) ...[
              const SizedBox(width: 12),
              Expanded(
                  child: _MetricTile(
                      icon: Icons.beach_access,
                      label: "Leave",
                      value: "${profile.leaveDays}d")),
            ],
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: ShapeDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.baSurfaceDark
            : Colors.white,
        shape: const StadiumBorder(),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.labelMedium),
      ]),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 18, color: cs.onPrimaryContainer),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: cs.onPrimaryContainer)),
          Text(value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: cs.onPrimaryContainer)),
        ]),
      ]),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  final _UserProfile profile;
  const _OverflowMenu({required this.profile});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(value: "edit", child: Text("Edit profile")),
        const PopupMenuItem(value: "settings", child: Text("Settings")),
        if (profile.staffNo != null)
          PopupMenuItem(
              value: "staff", child: Text("Staff No: ${profile.staffNo}")),
      ],
      onSelected: (v) {
        // defer route push until after the menu closes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (v == "edit") {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => const ProfileEditPage()),
            );
          }
        });
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final _UserProfile profile;
  const _Avatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if ((profile.avatarUrl ?? "").isNotEmpty) {
      return CircleAvatar(
          radius: 28, backgroundImage: NetworkImage(profile.avatarUrl!));
    }
    final parts = profile.name.trim().split(RegExp(r"\s+"));
    final initials = (parts.isNotEmpty ? parts.first[0] : "") +
        (parts.length > 1 ? parts.last[0] : "");
    return CircleAvatar(
      radius: 28,
      backgroundColor: cs.primaryContainer,
      child: Text(initials.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
    );
  }
}
