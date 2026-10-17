import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/activity_point_entity.dart';

class ActivitiesChart extends StatelessWidget {
  final List<ActivityPointEntity> points;

  const ActivitiesChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: Row(
              children: [
                // Y-Axis Labels (5h to 1h)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('5h', style: TextStyle(color: AppTheme.lightText, fontSize: 12)),
                    Text('4h', style: TextStyle(color: AppTheme.lightText, fontSize: 12)),
                    Text('3h', style: TextStyle(color: AppTheme.lightText, fontSize: 12)),
                    Text('2h', style: TextStyle(color: AppTheme.lightText, fontSize: 12)),
                    Text('1h', style: TextStyle(color: AppTheme.lightText, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 12),
                // Chart Area
                Expanded(
                  child: CustomPaint(
                    painter: _CurveChartPainter(points: points),
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // X-Axis Day Labels
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points.map((p) {
                final isSelected = p.isPeak;
                return Text(
                  p.dayShort,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.mutedText,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurveChartPainter extends CustomPainter {
  final List<ActivityPointEntity> points;

  _CurveChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Grid lines (horizontal light grid)
    final gridPaint = Paint()
      ..color = AppTheme.borderLight.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final double stepX = size.width / (points.length - 1);
    final List<Offset> coordinates = [];

    const double maxHeight = 5.0; // 5 hours max
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height - (points[i].durationHours / maxHeight * size.height).clamp(0.0, size.height);
      coordinates.add(Offset(x, y));
    }

    // Build smooth cubic bezier path
    final path = Path();
    path.moveTo(coordinates[0].dx, coordinates[0].dy);

    for (int i = 0; i < coordinates.length - 1; i++) {
      final current = coordinates[i];
      final next = coordinates[i + 1];
      final control1 = Offset(current.dx + (next.dx - current.dx) / 2, current.dy);
      final control2 = Offset(current.dx + (next.dx - current.dx) / 2, next.dy);
      path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, next.dx, next.dy);
    }

    // Gradient fill below path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryBlue.withValues(alpha: 0.18),
          AppTheme.primaryBlue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke path
    final strokePaint = Paint()
      ..color = AppTheme.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Draw peak point and tooltip for Wednesday (or isPeak)
    for (int i = 0; i < points.length; i++) {
      if (points[i].isPeak) {
        final pt = coordinates[i];

        // Draw dotted vertical guide line
        final guidePaint = Paint()
          ..color = AppTheme.primaryBlue.withValues(alpha: 0.4)
          ..strokeWidth = 1.5;

        double startY = pt.dy;
        while (startY < size.height) {
          canvas.drawLine(
            Offset(pt.dx, startY),
            Offset(pt.dx, (startY + 4).clamp(0, size.height)),
            guidePaint,
          );
          startY += 8;
        }

        // Draw outer dot
        canvas.drawCircle(
          pt,
          5,
          Paint()..color = AppTheme.primaryBlue,
        );
        // Draw inner white dot
        canvas.drawCircle(
          pt,
          2.5,
          Paint()..color = Colors.white,
        );

        // Draw Tooltip pill above the point
        final textSpan = TextSpan(
          text: points[i].tooltipText,
          style: const TextStyle(
            color: AppTheme.darkText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final tooltipWidth = textPainter.width + 16;
        const tooltipHeight = 24.0;
        final tooltipRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(pt.dx, pt.dy - 20),
            width: tooltipWidth,
            height: tooltipHeight,
          ),
          const Radius.circular(12),
        );

        // Tooltip shadow and background
        canvas.drawRRect(
          tooltipRect,
          Paint()..color = Colors.white,
        );
        canvas.drawRRect(
          tooltipRect,
          Paint()
            ..color = AppTheme.borderLight
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

        textPainter.paint(
          canvas,
          Offset(pt.dx - textPainter.width / 2, pt.dy - 20 - textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
