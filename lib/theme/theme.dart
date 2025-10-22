import 'package:flutter/material.dart';

final ThemeData light = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0A2342), // BA navy seed
  ),
);

final ThemeData dark = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0A2342), // BA navy seed
    brightness: Brightness.dark,
  ),
);
