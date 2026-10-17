import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/workout_entity.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutEntity workout;
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 180,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(workout.bgColorHex),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Left content: Title, Time, Badge, Location
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          workout.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          workout.category,
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                Text(
                  workout.timeString,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.mutedText,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        workout.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.bodyText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

            // Right side: Custom Stylized Runner Figure
            Positioned(
              right: 0,
              bottom: 0,
              top: 10,
              width: 130,
              child: CustomPaint(
                painter: _RunnerIllustrationPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RunnerIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Treadmill / platform line
    final platformPaint = Paint()
      ..color = AppTheme.illustrationTreadmillBelt
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final baseLineY = size.height - 12;
    canvas.drawLine(
      Offset(10, baseLineY),
      Offset(size.width - 5, baseLineY),
      platformPaint,
    );

    // Treadmill handle/front bar
    final barPaint = Paint()
      ..color = AppTheme.illustrationTreadmillBase
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width - 15, baseLineY),
      Offset(size.width - 15, baseLineY - 45),
      barPaint,
    );
    canvas.drawLine(
      Offset(size.width - 25, baseLineY - 45),
      Offset(size.width - 5, baseLineY - 45),
      barPaint,
    );

    // Small red light on treadmill console
    canvas.drawCircle(
      Offset(size.width - 10, baseLineY - 4),
      3,
      Paint()..color = AppTheme.illustrationJersey,
    );

    // Runner Leg - Left (reaching forward in stride)
    final blueLegPaint = Paint()
      ..color = AppTheme.illustrationShorts
      ..style = PaintingStyle.fill;

    final legPath1 = Path()
      ..moveTo(55, baseLineY - 55)
      ..lineTo(35, baseLineY - 25)
      ..lineTo(22, baseLineY - 5)
      ..lineTo(30, baseLineY - 5)
      ..lineTo(44, baseLineY - 28)
      ..lineTo(63, baseLineY - 50)
      ..close();
    canvas.drawPath(legPath1, blueLegPaint);

    // Runner Leg - Right (bent back pushing off)
    final legPath2 = Path()
      ..moveTo(58, baseLineY - 55)
      ..lineTo(75, baseLineY - 35)
      ..lineTo(68, baseLineY - 12)
      ..lineTo(60, baseLineY - 15)
      ..lineTo(66, baseLineY - 33)
      ..lineTo(52, baseLineY - 50)
      ..close();
    canvas.drawPath(legPath2, blueLegPaint);

    // Runner Torso / Red Coral Jacket
    final jacketPaint = Paint()
      ..color = AppTheme.illustrationShoe1
      ..style = PaintingStyle.fill;

    final torsoPath = Path()
      ..moveTo(55, baseLineY - 55)
      ..lineTo(50, baseLineY - 85)
      ..lineTo(78, baseLineY - 78)
      ..lineTo(88, baseLineY - 65)
      ..lineTo(70, baseLineY - 52)
      ..close();
    canvas.drawPath(torsoPath, jacketPaint);

    // Runner Arm - reaching forward
    final armPaint = Paint()
      ..color = AppTheme.illustrationShoe2
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(72, baseLineY - 75),
      Offset(88, baseLineY - 70),
      armPaint,
    );

    // Hand skin tone
    canvas.drawCircle(
      Offset(92, baseLineY - 69),
      4,
      Paint()..color = AppTheme.illustrationSkin,
    );

    // Runner Head & Beanie
    // Face / skin
    canvas.drawCircle(
      Offset(62, baseLineY - 92),
      8,
      Paint()..color = AppTheme.illustrationSkin,
    );

    // Blue beanie / athletic cap
    final capPaint = Paint()..color = AppTheme.primaryBlue;
    final capPath = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(61, baseLineY - 95), radius: 8),
        3.14,
        3.14,
      );
    canvas.drawPath(capPath, capPaint);
    // Beanie pompom
    canvas.drawCircle(
      Offset(58, baseLineY - 105),
      3.5,
      capPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
