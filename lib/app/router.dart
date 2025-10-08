import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/preprocess/preprocess_page.dart';
import '../features/build/build_page.dart';
import '../features/preview/preview_page.dart';
import '../features/profile/profile_page.dart';

final router = RouterConfig<Object>(
  routerDelegate: _TabRouterDelegate(),
  routeInformationParser: const _NoopParser(),
);

class _NoopParser extends RouteInformationParser<Object> {
  const _NoopParser();
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async => Object();
}

class _TabRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _index = 0;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DashboardPage(),
      const PreProcessPage(),
      const BuildBidPage(),
      const PreviewPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          _index = i;
          notifyListeners();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Pre-Process'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Build'),
          NavigationDestination(icon: Icon(Icons.visibility), label: 'Preview'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}
