import '../../../../core/utils/result.dart';
import '../entities/workout_entity.dart';
import '../entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';

abstract class IHomeRepository {
  Future<Result<List<WorkoutEntity>>> getUpcomingWorkouts();
  Future<Result<List<GymFacilityEntity>>> getNearbyGyms();
  Future<Result<List<ActivityPointEntity>>> getWeeklyActivities([String period = 'Weekly']);
}
