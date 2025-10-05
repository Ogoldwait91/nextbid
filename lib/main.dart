import 'package:flutter/material.dart';
import 'pages/auth/login_screen.dart';
import 'app/theme.dart';
import 'services/profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProfileStore.load();
  runApp(const NextBidApp());
}

class NextBidApp extends StatelessWidget {
  const NextBidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}

