import "package:flutter/material.dart";

// BA-ish palette
const Color baNavy = Color(0xFF0E1A2B);
const Color baNavyLight = Color(0xFF1A3E6A);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: baNavy,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF7F7FA),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    foregroundColor: baNavy,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: baNavy, fontWeight: FontWeight.w600, fontSize: 20,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF1F3F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: baNavy.withAlpha(20), // subtle highlight
    labelTextStyle: const MaterialStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: baNavy,
    brightness: Brightness.dark,
  ),
);
