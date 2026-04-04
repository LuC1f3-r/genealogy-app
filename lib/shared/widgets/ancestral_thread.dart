import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A dashed vertical line connecting life events — the "Ancestral Thread."
///
/// Represents the fragility and continuity of history; never a solid line.
class AncestralThread extends StatelessWidget {
  const AncestralThread({
    super.key,
    this.height = 48,
    this.color = AppColors.outlineVariant,
    this.opacity = 0.20,
    this.dashHeight = 4,
    this.dashGap = 4,
  });

  final double height;
  final Color color;
  final double opacity;
  final double dashHeight;
  final double dashGap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color.withValues(alpha: opacity),
          dashHeight: dashHeight,
          dashGap: dashGap,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.color,
    required this.dashHeight,
    required this.dashGap,
  });

  final Color color;
  final double dashHeight;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashHeight != dashHeight ||
      oldDelegate.dashGap != dashGap;
}
