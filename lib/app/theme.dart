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
  scaffoldBackgroundColor: Color(0xFFF7F7FA),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    foregroundColor: baNavy,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      color: baNavy,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  // NEW: CardThemeData (not CardTheme)
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: Color(0xFFF1F3F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    ),
  ),
  // Make indicatorColor const by using ARGB (≈20% alpha BA navy)
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Color(0x330E1A2B),
    labelTextStyle: WidgetStatePropertyAll(
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
