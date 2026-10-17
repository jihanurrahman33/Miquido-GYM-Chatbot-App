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

  Future<StatisticsDashboardData> execute() async {
    final metrics = await _repository.getUserMetrics();
    final weekDays = await _repository.getWeekDays();

    return StatisticsDashboardData(
      metrics: metrics,
      weekDays: weekDays,
    );
  }
}
