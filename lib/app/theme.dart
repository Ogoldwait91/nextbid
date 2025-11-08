import 'package:flutter/material.dart';

// BA-ish palette
const Color baNavy = Color(0xFF0E1A2B);
const Color baNavyLight = Color(0xFF1A3E6A);

// Unified text theme for NextBid
const TextTheme nextBidTextTheme = TextTheme(
  headlineLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  ),
  titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  bodyMedium: TextStyle(fontSize: 14, height: 1.4),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  ),
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: baNavy),
  textTheme: nextBidTextTheme,
  scaffoldBackgroundColor: const Color(0xFFF7F7FA),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    foregroundColor: baNavy,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: baNavy,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),

  // Keep visual consistency for cards
  // (using CardThemeData here because your current code compiles with it)
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
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
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    ),
  ),

  // indicatorColor at 20% alpha (BA navy)
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Color(0x330E1A2B),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: baNavy,
    brightness: Brightness.dark,
  ),
  textTheme: nextBidTextTheme,
);
