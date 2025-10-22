import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../services/auth_state.dart";

class LogoutLeading extends StatelessWidget {
  const LogoutLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: authState,
      builder: (context, loggedIn, _) {
        if (!loggedIn) return const SizedBox.shrink();
        return IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Sign out",
          onPressed: () {
            authState.value = false;
            context.go("/login");
          },
        );
      },
    );
  }
}
