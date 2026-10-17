import '../../../../core/utils/result.dart';
import '../entities/user_metric_entity.dart';

abstract class IStatisticsRepository {
  Future<Result<UserMetricEntity>> getUserMetrics([int? dayNumber]);
  Future<Result<List<DayProgressEntity>>> getWeekDays();
  Future<Result<UserMetricEntity>> updateHealthGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  });
}
