import "package:flutter/material.dart";
import "features/export_history/export_history_page.dart";

void main() {
  runApp(const _HistoryApp());
}

class _HistoryApp extends StatelessWidget {
  const _HistoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NextBid – Export History",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ExportHistoryPage(),
    );
  }
}
