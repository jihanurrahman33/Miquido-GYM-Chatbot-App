import '../../../../core/storage/storage_service.dart';
import '../models/user_metric_model.dart';
import '../../domain/entities/user_metric_entity.dart';

abstract class IStatisticsLocalDataSource {
  Future<UserMetricModel> getUserMetrics([int? dayNumber]);
  Future<List<DayProgressEntity>> getWeekDays();
  Future<UserMetricModel> updateGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  });
}

class StatisticsLocalDataSource implements IStatisticsLocalDataSource {
  final IStorageService _storageService;

  StatisticsLocalDataSource(this._storageService);

  @override
  Future<UserMetricModel> getUserMetrics([int? dayNumber]) async {
    final targetDay = dayNumber ?? 15;
    final cacheKey = 'user_metrics_$targetDay';
    final raw = _storageService.read<Map<String, dynamic>>(cacheKey);

    if (raw != null) {
      return UserMetricModel.fromJson(Map<String, dynamic>.from(raw));
    }

    // Default metrics dynamically tailored per day, with Day 15 matching Figma 403:3246
    UserMetricModel metrics;
    if (targetDay == 15) {
      metrics = UserMetricModel(
        date: DateTime(2022, 6, 15),
        formattedMonthYear: 'June 2022',
        calBurnt: '3.950',
        totalTime: '3h 14min',
        exercises: 15,
        breaks: 5,
        sleepHours: 6.083, // 6h 5min
        sleepTargetHours: 8.0,
        sleepDisplayText: '6h 5min/8h',
        calories: 1050,
        caloriesTarget: 2000,
        caloriesDisplayText: '1050/2000',
        steps: 2015,
        stepsTarget: 6000,
        stepsDisplayText: '2015/6000',
      );
    } else if (targetDay == 13) {
      metrics = UserMetricModel(
        date: DateTime(2022, 6, 13),
        formattedMonthYear: 'June 2022',
        calBurnt: '2.400',
        totalTime: '1h 50min',
        exercises: 10,
        breaks: 3,
        sleepHours: 7.2,
        sleepTargetHours: 8.0,
        sleepDisplayText: '7h 12min/8h',
        calories: 820,
        caloriesTarget: 2000,
        caloriesDisplayText: '820/2000',
        steps: 4200,
        stepsTarget: 6000,
        stepsDisplayText: '4200/6000',
      );
    } else {
      metrics = UserMetricModel(
        date: DateTime(2022, 6, targetDay),
        formattedMonthYear: 'June 2022',
        calBurnt: '${2.5 + (targetDay % 3) * 0.7}',
        totalTime: '${2 + (targetDay % 2)}h ${10 + targetDay * 2}min',
        exercises: 12 + (targetDay % 5),
        breaks: 4,
        sleepHours: 6.5 + (targetDay % 3) * 0.5,
        sleepTargetHours: 8.0,
        sleepDisplayText: '7h 00min/8h',
        calories: 900 + targetDay * 25,
        caloriesTarget: 2000,
        caloriesDisplayText: '${900 + targetDay * 25}/2000',
        steps: 2500 + targetDay * 120,
        stepsTarget: 6000,
        stepsDisplayText: '${2500 + targetDay * 120}/6000',
      );
    }

    await _storageService.write(cacheKey, metrics.toJson());
    return metrics;
  }

  @override
  Future<UserMetricModel> updateGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  }) async {
    final current = await getUserMetrics(15);
    final updated = UserMetricModel(
      date: current.date,
      formattedMonthYear: current.formattedMonthYear,
      calBurnt: current.calBurnt,
      totalTime: current.totalTime,
      exercises: current.exercises,
      breaks: current.breaks,
      sleepHours: current.sleepHours,
      sleepTargetHours: sleepTargetHours,
      sleepDisplayText: '${current.sleepHours.toStringAsFixed(1)}h/${sleepTargetHours.toInt()}h',
      calories: current.calories,
      caloriesTarget: caloriesTarget,
      caloriesDisplayText: '${current.calories}/$caloriesTarget',
      steps: current.steps,
      stepsTarget: stepsTarget,
      stepsDisplayText: '${current.steps}/$stepsTarget',
    );

    await _storageService.write('user_metrics_15', updated.toJson());
    return updated;
  }

  @override
  Future<List<DayProgressEntity>> getWeekDays() async {
    return const [
      DayProgressEntity(dayInitial: 'M', dayNumber: 13),
      DayProgressEntity(dayInitial: 'T', dayNumber: 14),
      DayProgressEntity(dayInitial: 'W', dayNumber: 15, isSelected: true),
      DayProgressEntity(dayInitial: 'T', dayNumber: 16),
      DayProgressEntity(dayInitial: 'F', dayNumber: 17),
      DayProgressEntity(dayInitial: 'S', dayNumber: 18),
      DayProgressEntity(dayInitial: 'S', dayNumber: 19),
    ];
  }
}
