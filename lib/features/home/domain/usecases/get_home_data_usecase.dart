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

  Future<HomeDashboardData> execute() async {
    final workouts = await _repository.getUpcomingWorkouts();
    final gyms = await _repository.getNearbyGyms();
    final activities = await _repository.getWeeklyActivities();

    return HomeDashboardData(
      workouts: workouts,
      nearbyGyms: gyms,
      weeklyActivities: activities,
    );
  }
}
