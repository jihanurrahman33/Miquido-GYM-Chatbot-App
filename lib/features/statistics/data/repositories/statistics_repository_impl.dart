import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_metric_entity.dart';
import '../../domain/repositories/i_statistics_repository.dart';
import '../datasources/statistics_local_datasource.dart';

class StatisticsRepositoryImpl implements IStatisticsRepository {
  final IStatisticsLocalDataSource _localDataSource;

  StatisticsRepositoryImpl(this._localDataSource);

  @override
  Future<Result<UserMetricEntity>> getUserMetrics([int? dayNumber]) async {
    try {
      final metrics = await _localDataSource.getUserMetrics(dayNumber);
      return Result.success(metrics);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load metrics: $e'));
    }
  }

  @override
  Future<Result<List<DayProgressEntity>>> getWeekDays() async {
    try {
      final days = await _localDataSource.getWeekDays();
      return Result.success(days);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load calendar days: $e'));
    }
  }

  @override
  Future<Result<UserMetricEntity>> updateHealthGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  }) async {
    try {
      final updated = await _localDataSource.updateGoals(
        sleepTargetHours: sleepTargetHours,
        caloriesTarget: caloriesTarget,
        stepsTarget: stepsTarget,
      );
      return Result.success(updated);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to update goals: $e'));
    }
  }
}
