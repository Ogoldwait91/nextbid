import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../shared/services/auth_state.dart";

import "../features/auth/login_page.dart";
import "../features/auth/signup_page.dart";

import "../features/dashboard/dashboard_page.dart";
import "../features/preprocess/preprocess_page.dart";
import "../features/build/build_page.dart";
import "../features/preview/preview_page.dart";
import "../features/profile/profile_page.dart";

final router = GoRouter(
  initialLocation: authState.value ? "/dashboard" : "/login",
  refreshListenable: authState, // <- re-run redirect when auth changes
  redirect: (context, state) {
    final logging =
        state.matchedLocation.startsWith("/login") ||
        state.matchedLocation.startsWith("/signup");
    final loggedIn = authState.value;
    if (!loggedIn && !logging) return "/login";
    if (loggedIn && logging) return "/dashboard";
    return null;
  },
  routes: [
    GoRoute(
      path: "/login",
      pageBuilder: (_, __) => const NoTransitionPage(child: LoginPage()),
    ),
    GoRoute(
      path: "/signup",
      pageBuilder: (_, __) => const NoTransitionPage(child: SignupPage()),
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              _RootShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/dashboard",
              pageBuilder:
                  (_, __) => const NoTransitionPage(child: DashboardPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/preprocess",
              pageBuilder:
                  (_, __) => const NoTransitionPage(child: PreProcessPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/build",
              pageBuilder:
                  (_, __) => const NoTransitionPage(child: BuildBidPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/preview",
              pageBuilder:
                  (_, __) => const NoTransitionPage(child: PreviewPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              pageBuilder:
                  (_, __) => const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _RootShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _RootShell({required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
          ),
          NavigationDestination(icon: Icon(Icons.tune), label: "Pre-Process"),
          NavigationDestination(icon: Icon(Icons.list_alt), label: "Build"),
          NavigationDestination(icon: Icon(Icons.visibility), label: "Preview"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
