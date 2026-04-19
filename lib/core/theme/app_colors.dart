import 'package:flutter/material.dart';

/// Palet warna monokromatik teal green untuk ROUTINE.
/// Mengikuti mockup: background terang + hijau teal sebagai satu-satunya brand color.
class AppColors {
  AppColors._();

  // Brand – teal green (dari mockup)
  static const Color primary = Color(0xFF00A676);
  static const Color primaryDark = Color(0xFF00664A);
  static const Color primaryMid = Color(0xFF22C58E);
  static const Color primaryLight = Color(0xFFC6F0DF);
  static const Color primarySoft = Color(0xFFE8F7F0);

  // Surface & background (putih bersih)
  static const Color lightBg = Color(0xFFF6FAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF0F5F2);

  // Dark mode
  static const Color darkBg = Color(0xFF0B1814);
  static const Color darkSurface = Color(0xFF12201A);
  static const Color darkSurfaceAlt = Color(0xFF1A2B24);

  // Text
  static const Color textPrimaryLight = Color(0xFF0E1A14);
  static const Color textSecondaryLight = Color(0xFF5B6B64);
  static const Color textTertiaryLight = Color(0xFF8A9690);
  static const Color textPrimaryDark = Color(0xFFF1F5F2);
  static const Color textSecondaryDark = Color(0xFFA3B0AA);

  // Heatmap tints
  static Color heatmap(int intensity) {
    switch (intensity) {
      case 0:
        return const Color(0xFFE8ECEA);
      case 1:
        return const Color(0xFFBFEBD7);
      case 2:
        return const Color(0xFF7FDBB5);
      case 3:
        return const Color(0xFF22C58E);
      case 4:
      default:
        return primary;
    }
  }

  /// Legacy API – semua entry sekarang monokromatik.
  /// Dipakai agar kode lama yang referensi `habitColors[index]` tetap jalan.
  static const List<Color> habitColors = [
    primary, primary, primary, primary,
    primary, primary, primary, primary,
    primary, primary, primary, primary,
  ];
}
