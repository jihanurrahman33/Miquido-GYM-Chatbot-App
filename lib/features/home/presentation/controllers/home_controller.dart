import 'package:get/get.dart';
import '../../domain/entities/workout_entity.dart';
import '../../domain/entities/activity_point_entity.dart';
import '../../../chatbot/domain/entities/gym_facility_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

class HomeController extends GetxController {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeController(this._getHomeDataUseCase);

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
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
      errorMessage.value = '';

      final result = await _getHomeDataUseCase.execute(selectedPeriod.value);
      result.when(
        success: (data) {
          workouts.assignAll(data.workouts);
          nearbyGyms.assignAll(data.nearbyGyms);
          weeklyActivities.assignAll(data.weeklyActivities);
        },
        failure: (failure) {
          errorMessage.value = failure.message;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load home data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePeriod(String newPeriod) async {
    selectedPeriod.value = newPeriod;
    final result = await _getHomeDataUseCase.getActivitiesForPeriod(newPeriod);
    result.when(
      success: (points) {
        weeklyActivities.assignAll(points);
      },
      failure: (_) {},
    );
  }
}
