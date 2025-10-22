import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import 'package:nextbid_demo/shared/services/profile_state.dart';

class ProfileChip extends StatelessWidget {
  const ProfileChip({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profileState,
      builder: (context, _) {
        final n = profileState.name.trim();
        final initials =
            (n.isEmpty
                    ? "NB"
                    : n
                        .split(RegExp(r"\\s+"))
                        .where((w) => w.isNotEmpty)
                        .map((w) => w[0])
                        .take(2)
                        .join())
                .toUpperCase();

        final line2 = () {
          final base =
              "${profileState.rank} ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ ${profileState.crewCode}";
          if (profileState.seniority != null &&
              profileState.cohortSize != null) {
            return "$base ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ SNR ${profileState.seniority}/${profileState.cohortSize}";
          }
          return base;
        }();

        return InkWell(
          onTap: () => context.go("/profile"),
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
                    n.isEmpty ? "Unnamed Pilot" : n,
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
