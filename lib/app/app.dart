import 'package:flutter/material.dart';
import 'package:nextbid_demo/app/router.dart';
import 'package:nextbid_demo/app/theme.dart';

class NextBidApp extends StatelessWidget {
  const NextBidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NextBid',
      debugShowCheckedModeBanner: false,

      // Use the unified themes we defined in theme.dart
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,
    );
  }
}
