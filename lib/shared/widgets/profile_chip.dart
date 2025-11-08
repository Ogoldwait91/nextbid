import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbid_demo/shared/services/profile_state.dart';

class ProfileChip extends StatelessWidget {
  const ProfileChip({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profileState,
      builder: (context, _) {
        final n = profileState.name.trim();

        // Build two-letter initials from the name (defaults to "NB")
        final initials =
            (n.isEmpty
                    ? 'NB'
                    : n
                        .split(RegExp(r'\s+')) // split on whitespace
                        .where((w) => w.isNotEmpty)
                        .map((w) => w[0])
                        .take(2)
                        .join())
                .toUpperCase();

        // Secondary line under the name: "RANK • CREWCODE [• SNR X/Y]"
        final base = '${profileState.rank} • ${profileState.crewCode}';
        final line2 =
            (profileState.seniority != null && profileState.cohortSize != null)
                ? '$base • SNR ${profileState.seniority}/${profileState.cohortSize}'
                : base;

        return InkWell(
          onTap: () => context.go('/profile'),
          borderRadius: BorderRadius.circular(999),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.isEmpty ? 'Unnamed Pilot' : n,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    line2,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
