import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_metric_entity.dart';

class WeekCalendarStrip extends StatelessWidget {
  final List<DayProgressEntity> days;
  final int selectedIndex;
  final ValueChanged<int> onSelectDay;

  const WeekCalendarStrip({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        final day = days[index];
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onSelectDay(index),
          child: Column(
            children: [
              Text(
                day.dayInitial,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.primaryBlue.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.navBarDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.dayNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.mutedText,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
