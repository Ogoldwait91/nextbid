import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => const _Scaffold(title: 'Dashboard');
}

class _Scaffold extends StatelessWidget {
  final String title;
  const _Scaffold({required this.title});
  @override
  Widget build(BuildContext context) => Center(child: Text(title));
}
