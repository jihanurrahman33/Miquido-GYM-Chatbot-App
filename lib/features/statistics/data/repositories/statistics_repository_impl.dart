import '../../domain/entities/user_metric_entity.dart';
import '../../domain/repositories/i_statistics_repository.dart';
import '../datasources/statistics_local_datasource.dart';

class StatisticsRepositoryImpl implements IStatisticsRepository {
  final IStatisticsLocalDataSource _localDataSource;

  StatisticsRepositoryImpl(this._localDataSource);

  @override
  Future<UserMetricEntity> getUserMetrics() {
    return _localDataSource.getUserMetrics();
  }

  @override
  Future<List<DayProgressEntity>> getWeekDays() {
    return _localDataSource.getWeekDays();
  }
}
