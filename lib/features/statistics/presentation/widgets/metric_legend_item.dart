import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MetricLegendItem extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String valueText;

  const MetricLegendItem({
    super.key,
    required this.dotColor,
    required this.title,
    required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              valueText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.mutedText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
