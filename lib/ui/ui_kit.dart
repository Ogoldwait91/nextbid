import 'package:flutter/material.dart';

/// Rounded section card with standard padding.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: padding, child: child));
  }
}

/// Title row like â€œTrend Dashboardâ€ with an optional trailing action.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(children: [
      Expanded(
          child: Text(title,
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
      if (trailing != null) trailing!,
    ]);
  }
}

/// Chevron tile (rounded ListTile with chevron).
class ChevronTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  const ChevronTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.onTap,
      this.leading,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}

/// Small stat pill for inline metrics.
class StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const StatPill(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          const ShapeDecoration(shape: StadiumBorder(), color: Colors.white),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Text('$label: ',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
        Text(value, style: Theme.of(context).textTheme.labelMedium),
      ]),
    );
  }
}

/// Simple heatmap grid (weeks x 7 days). Pass 0..1 values for intensity.
class Heatmap extends StatelessWidget {
  final List<List<double>> weeks; // weeks[week][day]
  const Heatmap({super.key, required this.weeks});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: labels.map((d) => _dayLabel(context, d)).toList()),
        const SizedBox(height: 8),
        Column(
          children: weeks
              .map((week) => Row(
                    children: week.map((v) => _cell(cs, v)).toList(),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _dayLabel(BuildContext context, String d) => SizedBox(
      width: 28,
      child: Center(
          child: Text(d, style: Theme.of(context).textTheme.labelSmall)));

  Widget _cell(ColorScheme cs, double v) {
    final val = v.clamp(0.0, 1.0);
    final color =
        Color.lerp(cs.secondary.withValues(alpha: 0.15), cs.secondary, val)!;
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.all(3),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
    );
  }
}
