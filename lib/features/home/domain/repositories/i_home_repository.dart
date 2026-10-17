import '../entities/workout_entity.dart';
import '../entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';

abstract class IHomeRepository {
  Future<List<WorkoutEntity>> getUpcomingWorkouts();
  Future<List<GymFacilityEntity>> getNearbyGyms();
  Future<List<ActivityPointEntity>> getWeeklyActivities();
}
