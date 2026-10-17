import 'package:get/get.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

class HomeController extends GetxController {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeController(this._getHomeDataUseCase);

  final RxBool isLoading = true.obs;
  final RxList<WorkoutEntity> workouts = <WorkoutEntity>[].obs;
  final RxList<GymFacilityEntity> nearbyGyms = <GymFacilityEntity>[].obs;
  final RxList<ActivityPointEntity> weeklyActivities = <ActivityPointEntity>[].obs;
  final RxString selectedPeriod = 'Weekly'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      final data = await _getHomeDataUseCase.execute();
      workouts.assignAll(data.workouts);
      nearbyGyms.assignAll(data.nearbyGyms);
      weeklyActivities.assignAll(data.weeklyActivities);
    } catch (e) {
      // In case of error
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String newPeriod) {
    selectedPeriod.value = newPeriod;
  }
}
