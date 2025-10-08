import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../shared/services/auth_state.dart";
import "../../shared/widgets/logout_leading.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const LogoutLeading(), title: const Text("Profile")),
      body: Center(
        child: FilledButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text("Sign out"),
          onPressed: () {
            authState.value = false;
            context.go("/login");
          },
        ),
      ),
    );
  }
}
