import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CaloriesBarChart extends StatelessWidget {
  const CaloriesBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 7 days calories data
    final data = [
      {'day': 'M', 'val': 420},
      {'day': 'T', 'val': 350},
      {'day': 'W', 'val': 540}, // Highlighted
      {'day': 'T', 'val': 280},
      {'day': 'F', 'val': 490},
      {'day': 'S', 'val': 610},
      {'day': 'S', 'val': 390},
    ];

    const double maxVal = 700.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Weekly Calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText,
                ),
              ),
              Text(
                'Avg 440 kcal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ringCalories,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final isWed = item['day'] == 'W';
                final val = (item['val'] as int).toDouble();
                final barHeight = (val / maxVal * 100).clamp(15.0, 100.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 28,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: isWed
                            ? AppTheme.ringCalories
                            : AppTheme.ringCalories.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['day'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isWed ? FontWeight.w700 : FontWeight.w500,
                        color: isWed ? AppTheme.darkText : AppTheme.mutedText,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
