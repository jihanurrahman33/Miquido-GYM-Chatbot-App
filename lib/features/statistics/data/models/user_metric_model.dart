import '../../domain/entities/user_metric_entity.dart';

class UserMetricModel extends UserMetricEntity {
  const UserMetricModel({
    required super.date,
    required super.formattedMonthYear,
    required super.calBurnt,
    required super.totalTime,
    required super.exercises,
    required super.breaks,
    required super.sleepHours,
    required super.sleepTargetHours,
    required super.sleepDisplayText,
    required super.calories,
    required super.caloriesTarget,
    required super.caloriesDisplayText,
    required super.steps,
    required super.stepsTarget,
    required super.stepsDisplayText,
  });

  factory UserMetricModel.fromJson(Map<String, dynamic> json) {
    return UserMetricModel(
      date: DateTime.parse(json['date'] as String),
      formattedMonthYear: json['formattedMonthYear'] as String,
      calBurnt: json['calBurnt'] as String,
      totalTime: json['totalTime'] as String,
      exercises: (json['exercises'] as num).toInt(),
      breaks: (json['breaks'] as num).toInt(),
      sleepHours: (json['sleepHours'] as num).toDouble(),
      sleepTargetHours: (json['sleepTargetHours'] as num).toDouble(),
      sleepDisplayText: json['sleepDisplayText'] as String,
      calories: (json['calories'] as num).toInt(),
      caloriesTarget: (json['caloriesTarget'] as num).toInt(),
      caloriesDisplayText: json['caloriesDisplayText'] as String,
      steps: (json['steps'] as num).toInt(),
      stepsTarget: (json['stepsTarget'] as num).toInt(),
      stepsDisplayText: json['stepsDisplayText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'formattedMonthYear': formattedMonthYear,
      'calBurnt': calBurnt,
      'totalTime': totalTime,
      'exercises': exercises,
      'breaks': breaks,
      'sleepHours': sleepHours,
      'sleepTargetHours': sleepTargetHours,
      'sleepDisplayText': sleepDisplayText,
      'calories': calories,
      'caloriesTarget': caloriesTarget,
      'caloriesDisplayText': caloriesDisplayText,
      'steps': steps,
      'stepsTarget': stepsTarget,
      'stepsDisplayText': stepsDisplayText,
    };
  }
}
