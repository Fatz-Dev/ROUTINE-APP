import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/utils/haptic_utils.dart';

/// Tombol besar berikon sidik jari – animasi tekan + pulse.
class FingerprintButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final String label;

  const FingerprintButton({
    super.key,
    required this.onPressed,
    this.color = Colors.white,
    this.size = 104,
    this.label = 'Tekan untuk Selesai',
  });

  @override
  State<FingerprintButton> createState() => _FingerprintButtonState();
}

class _FingerprintButtonState extends State<FingerprintButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    lowerBound: 0,
    upperBound: 0.08,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await HapticUtils.fingerprintSuccess();
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) {
              return Transform.scale(scale: 1 - _ctrl.value, child: child);
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.fingerprint_rounded,
                size: widget.size * 0.55,
                color: widget.color == Colors.white
                    ? Colors.black87
                    : Colors.white,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scaleXY(
                  begin: 1,
                  end: 1.05,
                  duration: 1400.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scaleXY(
                  begin: 1.05,
                  end: 1,
                  duration: 1400.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.label,
          style: TextStyle(
            color: widget.color == Colors.white
                ? Colors.white70
                : Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
