import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbid_demo/app/state.dart';
import 'package:nextbid_demo/features/auth/login_page.dart';
import 'package:nextbid_demo/features/auth/signup_page.dart';
import 'package:nextbid_demo/features/pre_process/pre_process_page.dart';
import 'package:nextbid_demo/features/build/build_page.dart';
import 'package:nextbid_demo/features/dashboard/dashboard_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: AppState.instance,
  redirect: (context, state) {
    final loggedIn = AppState.instance.isLoggedIn;
    final loc = state.matchedLocation;
    final goingAuth = (loc == '/login' || loc == '/signup');

    if (!loggedIn && !goingAuth) {
      // must be logged in to view app pages
      return '/login';
    }
    if (loggedIn && goingAuth) {
      // don’t show login/signup when already logged in
      return '/dashboard';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (c,s) => const LoginPage()),
    GoRoute(path: '/signup', builder: (c,s) => const SignupPage()),
    GoRoute(path: '/pre-process', builder: (c,s) => const PreProcessPage()),
    GoRoute(path: '/build', builder: (c,s) => const BuildBidPage()),
    GoRoute(path: '/dashboard', builder: (c,s) => const DashboardPage()),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: \${state.uri}')),
  ),
);
