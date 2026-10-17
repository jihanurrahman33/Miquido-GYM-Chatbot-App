import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeLocalDataSource _localDataSource;

  HomeRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<WorkoutEntity>>> getUpcomingWorkouts() async {
    try {
      final workouts = await _localDataSource.getWorkouts();
      return Result.success(workouts);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load upcoming workouts: $e'));
    }
  }

  @override
  Future<Result<List<GymFacilityEntity>>> getNearbyGyms() async {
    try {
      final gyms = await _localDataSource.getNearbyGyms();
      return Result.success(gyms);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load nearby gyms: $e'));
    }
  }

  @override
  Future<Result<List<ActivityPointEntity>>> getWeeklyActivities([String period = 'Weekly']) async {
    try {
      final activities = await _localDataSource.getWeeklyActivities(period);
      return Result.success(activities);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load activities: $e'));
    }
  }
}
