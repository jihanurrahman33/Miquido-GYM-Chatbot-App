import '../../../../core/storage/storage_service.dart';
import '../models/user_metric_model.dart';
import '../../domain/entities/user_metric_entity.dart';

abstract class IStatisticsLocalDataSource {
  Future<UserMetricModel> getUserMetrics();
  Future<List<DayProgressEntity>> getWeekDays();
}

class StatisticsLocalDataSource implements IStatisticsLocalDataSource {
  final IStorageService _storageService;

  StatisticsLocalDataSource(this._storageService);

  @override
  Future<UserMetricModel> getUserMetrics() async {
    final raw = _storageService.read<Map<String, dynamic>>('user_metrics');
    if (raw != null) {
      return UserMetricModel.fromJson(Map<String, dynamic>.from(raw));
    }

    // Default metrics exactly matching Figma 403:3246
    final defaults = UserMetricModel(
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

    await _storageService.write('user_metrics', defaults.toJson());
    return defaults;
  }

  @override
  Future<List<DayProgressEntity>> getWeekDays() async {
    // Days matching Figma 403:3246 (M 13, T 14, W 15 [selected], T 16, F 17, S 18, S 19)
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
