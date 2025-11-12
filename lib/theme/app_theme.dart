import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/material.dart";

class AppTheme {
  // British Airways-ish palette
  static const _navy = Color(0xFF0C2340);
  static const _blue = Color(0xFF0032A0);
  static const _red = Color(0xFFBA0C2F);
  static const _grey = Color(0xFF6E7781);

  static ThemeData get light {
    final base = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: _blue,
        primaryContainer: Color(0xFF2949C6),
        secondary: _red,
        secondaryContainer: Color(0xFFD43D57),
        tertiary: _navy,
        tertiaryContainer: Color(0xFF314A70),
        appBarColor: _navy,
        error: Color(0xFFB00020),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 16,
        elevatedButtonRadius: 16,
        cardRadius: 20,
        dialogRadius: 20,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 16,
        snackBarElevation: 6,
      ),
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      visualDensity: VisualDensity.standard,
      fontFamily: "Inter",
    );

    return base.copyWith(
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: base.cardTheme.copyWith(
        margin: const EdgeInsets.all(12),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(color: _grey),
      ),
    );
  }

  static ThemeData get dark {
    final base = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: _blue,
        primaryContainer: Color(0xFF152867),
        secondary: _red,
        secondaryContainer: Color(0xFF7A1624),
        tertiary: _navy,
        tertiaryContainer: Color(0xFF22304A),
        appBarColor: _navy,
        error: Color(0xFFCF6679),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 8,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 16,
        elevatedButtonRadius: 16,
        cardRadius: 20,
        dialogRadius: 20,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 16,
        snackBarElevation: 6,
      ),
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      visualDensity: VisualDensity.standard,
      fontFamily: "Inter",
    );

    return base.copyWith(
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: base.cardTheme.copyWith(
        margin: const EdgeInsets.all(12),
        elevation: 1,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(color: Colors.white60),
      ),
    );
  }
}
