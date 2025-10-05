import 'package:flutter/material.dart';

/// One namespace for all app styling.
abstract class AppTheme {
  // ===== BA palette =====
  static const baNavy = Color(0xFF0A2342);
  static const baNavyLight = Color(0xFF15325F);
  static const baSurfaceLight = Color(0xFFF6F8FC);
  static const baSurfaceDark = Color(0xFF0F1C33);
  static const baRed = Color(0xFFE4002B);
  static const baGold = Color(0xFFC8A45D);

  // Shared input style (light/dark aware)
  static InputDecorationTheme _input(Brightness b) {
    final isDark = b == Brightness.dark;
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF2B3550) : const Color(0xFFDCE1EA),
      ),
    );
    return InputDecorationTheme(
      filled: true,
      // NOTE: keep constants to avoid withOpacity deprecation warnings
      fillColor: isDark ? const Color(0x1415325F) : const Color(0x0D0A2342),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: base,
      enabledBorder: base,
      focusedBorder: base.copyWith(
        borderSide: const BorderSide(color: baRed, width: 2),
      ),
      errorBorder: base.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: base.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      labelStyle: TextStyle(
        color: isDark ? const Color(0xFFBAC7E0) : const Color(0xFF33415C),
      ),
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF8FA1C6) : const Color(0xFF6C7A96),
      ),
      prefixIconColor:
          isDark ? const Color(0xFFBAC7E0) : const Color(0xFF33415C),
    );
  }

  // ===== Light Theme =====
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: baNavy,
      brightness: Brightness.light,
      primary: baNavy,
      secondary: baRed,
      tertiary: baGold,
      surface: baSurfaceLight,
    ),
    scaffoldBackgroundColor: baSurfaceLight,
    inputDecorationTheme: _input(Brightness.light),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 10,
      surfaceTintColor: Colors.transparent, // crisp whites
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Colors.white,
      selectedTileColor: baNavy.withValues(alpha: 0.06),
      iconColor: baNavy,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.black.withValues(alpha: 0.06),
      thickness: 1,
      space: 24,
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: Color(0xFFE8EDF5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: baNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: baNavy,
        side: const BorderSide(color: baNavy, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );

  // ===== Dark Theme =====
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: baNavy,
      brightness: Brightness.dark,
      primary: baNavyLight,
      secondary: baRed,
      tertiary: baGold,
      surface: baSurfaceDark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0B1628),
    inputDecorationTheme: _input(Brightness.dark),
    cardTheme: CardThemeData(
      color: const Color(0xFF0F1C33),
      elevation: 12,
      shadowColor: Colors.black54,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 1,
      surfaceTintColor: Colors.transparent,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: const Color(0xFF0F1C33),
      selectedTileColor: baNavyLight.withValues(alpha: 0.18),
      iconColor: Colors.white70,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF22304A),
      thickness: 1,
      space: 24,
    ),
    chipTheme: const ChipThemeData(shape: StadiumBorder()),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: Color(0xFF17243C),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: baNavyLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: baNavyLight, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
