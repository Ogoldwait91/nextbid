import 'package:flutter/material.dart';
import 'package:nextbid_demo/app/router.dart';
import 'theme/theme.dart' as theme;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NextBidApp());
}

class NextBidApp extends StatelessWidget {
  const NextBidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NextBid Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.light,      // uses top-level themes from theme.dart
      darkTheme: theme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
