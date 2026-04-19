import 'package:flutter/services.dart';

/// Helper feedback haptic untuk interaksi "game-like".
class HapticUtils {
  HapticUtils._();

  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> select() => HapticFeedback.selectionClick();

  /// Dipanggil ketika tombol sidik jari ditekan – efek "success".
  static Future<void> fingerprintSuccess() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    await HapticFeedback.lightImpact();
  }
}
