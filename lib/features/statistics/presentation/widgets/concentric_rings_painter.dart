import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ConcentricProgressRings extends StatelessWidget {
  final double sleepProgress; // 0.0 - 1.0
  final double caloriesProgress; // 0.0 - 1.0
  final double stepsProgress; // 0.0 - 1.0
  final double size;

  const ConcentricProgressRings({
    super.key,
    required this.sleepProgress,
    required this.caloriesProgress,
    required this.stepsProgress,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ConcentricRingsPainter(
          sleepProgress: sleepProgress,
          caloriesProgress: caloriesProgress,
          stepsProgress: stepsProgress,
        ),
      ),
    );
  }
}

class _ConcentricRingsPainter extends CustomPainter {
  final double sleepProgress;
  final double caloriesProgress;
  final double stepsProgress;

  _ConcentricRingsPainter({
    required this.sleepProgress,
    required this.caloriesProgress,
    required this.stepsProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.082; // ~15px on 180px
    final gap = strokeWidth + 6;

    // Radii from outside in
    final rSleep = (size.width / 2) - strokeWidth;
    final rCalories = rSleep - gap;
    final rSteps = rCalories - gap;

    _drawRing(
      canvas: canvas,
      center: center,
      radius: rSleep,
      strokeWidth: strokeWidth,
      progress: sleepProgress,
      activeColor: AppTheme.ringSleep,
      bgColor: AppTheme.ringSleep.withValues(alpha: 0.15),
    );

    _drawRing(
      canvas: canvas,
      center: center,
      radius: rCalories,
      strokeWidth: strokeWidth,
      progress: caloriesProgress,
      activeColor: AppTheme.ringCalories,
      bgColor: AppTheme.ringCalories.withValues(alpha: 0.15),
    );

    _drawRing(
      canvas: canvas,
      center: center,
      radius: rSteps,
      strokeWidth: strokeWidth,
      progress: stepsProgress,
      activeColor: AppTheme.ringSteps,
      bgColor: AppTheme.ringSteps.withValues(alpha: 0.15),
    );
  }

  void _drawRing({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double strokeWidth,
    required double progress,
    required Color activeColor,
    required Color bgColor,
  }) {
    // Background full track
    final bgPaint = Paint()
      ..color = bgColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0) return;

    // Active progress arc starting from top (-pi / 2)
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);

    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );

    // Tip end-point dot with white inner circle matching Figma
    final endAngle = startAngle + sweepAngle;
    final endX = center.dx + radius * cos(endAngle);
    final endY = center.dy + radius * sin(endAngle);
    final tipCenter = Offset(endX, endY);

    // Inner bright center dot
    canvas.drawCircle(
      tipCenter,
      strokeWidth * 0.28,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingsPainter oldDelegate) {
    return oldDelegate.sleepProgress != sleepProgress ||
        oldDelegate.caloriesProgress != caloriesProgress ||
        oldDelegate.stepsProgress != stepsProgress;
  }
}
