class UserMetricEntity {
  final DateTime date;
  final String formattedMonthYear;
  final String calBurnt; // e.g. "3.950"
  final String totalTime; // e.g. "3h 14min"
  final int exercises; // e.g. 15
  final int breaks; // e.g. 5

  // Daily progress metrics
  final double sleepHours; // e.g. 6.083 (6h 5min)
  final double sleepTargetHours; // 8.0
  final String sleepDisplayText; // "6h 5min/8h"

  final int calories; // 1050
  final int caloriesTarget; // 2000
  final String caloriesDisplayText; // "1050/2000"

  final int steps; // 2015
  final int stepsTarget; // 6000
  final String stepsDisplayText; // "2015/6000"

  const UserMetricEntity({
    required this.date,
    required this.formattedMonthYear,
    required this.calBurnt,
    required this.totalTime,
    required this.exercises,
    required this.breaks,
    required this.sleepHours,
    required this.sleepTargetHours,
    required this.sleepDisplayText,
    required this.calories,
    required this.caloriesTarget,
    required this.caloriesDisplayText,
    required this.steps,
    required this.stepsTarget,
    required this.stepsDisplayText,
  });

  double get sleepProgress => (sleepHours / sleepTargetHours).clamp(0.0, 1.0);
  double get caloriesProgress => (calories / caloriesTarget).clamp(0.0, 1.0);
  double get stepsProgress => (steps / stepsTarget).clamp(0.0, 1.0);
}

class DayProgressEntity {
  final String dayInitial; // 'M', 'T', 'W', 'T', 'F', 'S', 'S'
  final int dayNumber; // 13, 14, 15, 16, 17, 18, 19
  final bool isSelected;

  const DayProgressEntity({
    required this.dayInitial,
    required this.dayNumber,
    this.isSelected = false,
  });
}
