import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Font display untuk heading besar (Playfair Display bold).
  static TextStyle displayStyle({
    required Color color,
    double size = 44,
    FontWeight weight = FontWeight.w800,
    double height = 1.05,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Font brand (letter-spacing wide) untuk logo "ROUTINE".
  static TextStyle brandLogoStyle({
    required Color color,
    double size = 22,
    FontWeight weight = FontWeight.w800,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 3.6,
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimaryLight,
      displayColor: AppColors.textPrimaryLight,
    );
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        surface: AppColors.lightSurface,
        surfaceContainerHighest: AppColors.lightSurfaceAlt,
      ),
      scaffoldBackgroundColor: AppColors.lightBg,
      textTheme: textTheme.copyWith(
        displayLarge: displayStyle(color: AppColors.textPrimaryLight, size: 48),
        displayMedium: displayStyle(color: AppColors.textPrimaryLight, size: 40),
        displaySmall: displayStyle(color: AppColors.textPrimaryLight, size: 32),
        headlineLarge: displayStyle(color: AppColors.textPrimaryLight, size: 28),
        headlineMedium: displayStyle(color: AppColors.textPrimaryLight, size: 24),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimaryLight,
          letterSpacing: 0.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dividerColor: Colors.grey.withValues(alpha: 0.15),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimaryDark,
      displayColor: AppColors.textPrimaryDark,
    );
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.primaryMid,
        surface: AppColors.darkSurface,
        surfaceContainerHighest: AppColors.darkSurfaceAlt,
      ),
      scaffoldBackgroundColor: AppColors.darkBg,
      textTheme: textTheme.copyWith(
        displayLarge: displayStyle(color: AppColors.textPrimaryDark, size: 48),
        displayMedium: displayStyle(color: AppColors.textPrimaryDark, size: 40),
        displaySmall: displayStyle(color: AppColors.textPrimaryDark, size: 32),
        headlineLarge: displayStyle(color: AppColors.textPrimaryDark, size: 28),
        headlineMedium: displayStyle(color: AppColors.textPrimaryDark, size: 24),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMid,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: const StadiumBorder(),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.08),
    );
  }
}
