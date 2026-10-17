import '../entities/user_metric_entity.dart';

abstract class IStatisticsRepository {
  Future<UserMetricEntity> getUserMetrics();
  Future<List<DayProgressEntity>> getWeekDays();
}
