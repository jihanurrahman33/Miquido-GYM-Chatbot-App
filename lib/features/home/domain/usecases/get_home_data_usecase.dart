import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/workout_entity.dart';
import '../entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../repositories/i_home_repository.dart';

class HomeDashboardData {
  final List<WorkoutEntity> workouts;
  final List<GymFacilityEntity> nearbyGyms;
  final List<ActivityPointEntity> weeklyActivities;

  const HomeDashboardData({
    required this.workouts,
    required this.nearbyGyms,
    required this.weeklyActivities,
  });
}

class GetHomeDataUseCase {
  final IHomeRepository _repository;

  GetHomeDataUseCase(this._repository);

  Future<Result<HomeDashboardData>> execute([String period = 'Weekly']) async {
    try {
      final workoutsResult = await _repository.getUpcomingWorkouts();
      final gymsResult = await _repository.getNearbyGyms();
      final activitiesResult = await _repository.getWeeklyActivities(period);

      if (workoutsResult.isFailure) return Result.failure(workoutsResult.failure);
      if (gymsResult.isFailure) return Result.failure(gymsResult.failure);
      if (activitiesResult.isFailure) return Result.failure(activitiesResult.failure);

      return Result.success(HomeDashboardData(
        workouts: workoutsResult.data,
        nearbyGyms: gymsResult.data,
        weeklyActivities: activitiesResult.data,
      ));
    } catch (e) {
      return Result.failure(UnexpectedFailure('Failed to load dashboard data: $e'));
    }
  }

  Future<Result<List<ActivityPointEntity>>> getActivitiesForPeriod(String period) {
    return _repository.getWeeklyActivities(period);
  }
}
