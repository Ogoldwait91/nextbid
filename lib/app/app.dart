import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class NextBidApp extends StatelessWidget {
  const NextBidApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NextBid',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
