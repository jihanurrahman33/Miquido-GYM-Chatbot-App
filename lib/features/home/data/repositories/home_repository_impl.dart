import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeLocalDataSource _localDataSource;

  HomeRepositoryImpl(this._localDataSource);

  @override
  Future<List<WorkoutEntity>> getUpcomingWorkouts() async {
    return _localDataSource.getWorkouts();
  }

  @override
  Future<List<GymFacilityEntity>> getNearbyGyms() async {
    return _localDataSource.getNearbyGyms();
  }

  @override
  Future<List<ActivityPointEntity>> getWeeklyActivities() async {
    return _localDataSource.getWeeklyActivities();
  }
}
