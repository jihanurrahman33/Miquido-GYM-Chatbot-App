import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_metric_entity.dart';
import '../repositories/i_statistics_repository.dart';

class StatisticsDashboardData {
  final UserMetricEntity metrics;
  final List<DayProgressEntity> weekDays;

  const StatisticsDashboardData({
    required this.metrics,
    required this.weekDays,
  });
}

class GetUserMetricsUseCase {
  final IStatisticsRepository _repository;

  GetUserMetricsUseCase(this._repository);

  Future<Result<StatisticsDashboardData>> execute([int? dayNumber]) async {
    try {
      final metricsResult = await _repository.getUserMetrics(dayNumber);
      final weekDaysResult = await _repository.getWeekDays();

      if (metricsResult.isFailure) return Result.failure(metricsResult.failure);
      if (weekDaysResult.isFailure) return Result.failure(weekDaysResult.failure);

      return Result.success(StatisticsDashboardData(
        metrics: metricsResult.data,
        weekDays: weekDaysResult.data,
      ));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Failed to load metrics: $e'));
    }
  }

  Future<Result<UserMetricEntity>> getMetricsForDay(int dayNumber) {
    return _repository.getUserMetrics(dayNumber);
  }

  Future<Result<UserMetricEntity>> updateGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  }) {
    return _repository.updateHealthGoals(
      sleepTargetHours: sleepTargetHours,
      caloriesTarget: caloriesTarget,
      stepsTarget: stepsTarget,
    );
  }
}
