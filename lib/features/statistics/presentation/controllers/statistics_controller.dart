import 'package:get/get.dart';
import '../../domain/entities/user_metric_entity.dart';
import '../../domain/usecases/get_user_metrics_usecase.dart';

class StatisticsController extends GetxController {
  final GetUserMetricsUseCase _getUserMetricsUseCase;

  StatisticsController(this._getUserMetricsUseCase);

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserMetricEntity> metrics = Rxn<UserMetricEntity>();
  final RxList<DayProgressEntity> weekDays = <DayProgressEntity>[].obs;
  final RxInt selectedDayIndex = 2.obs; // Default to Wednesday 15

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final targetDay = weekDays.isNotEmpty ? weekDays[selectedDayIndex.value].dayNumber : 15;
      final result = await _getUserMetricsUseCase.execute(targetDay);
      result.when(
        success: (data) {
          metrics.value = data.metrics;
          weekDays.assignAll(data.weekDays);
        },
        failure: (failure) {
          errorMessage.value = failure.message;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to load statistics: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDay(int index) async {
    if (index >= weekDays.length) return;
    selectedDayIndex.value = index;

    final targetDay = weekDays[index].dayNumber;
    final result = await _getUserMetricsUseCase.getMetricsForDay(targetDay);
    result.when(
      success: (dayMetrics) {
        metrics.value = dayMetrics;
      },
      failure: (_) {},
    );
  }

  Future<void> updateHealthGoals({
    required double sleepTargetHours,
    required int caloriesTarget,
    required int stepsTarget,
  }) async {
    final result = await _getUserMetricsUseCase.updateGoals(
      sleepTargetHours: sleepTargetHours,
      caloriesTarget: caloriesTarget,
      stepsTarget: stepsTarget,
    );
    result.when(
      success: (updated) {
        metrics.value = updated;
        Get.snackbar(
          'Goals Updated 🎯',
          'Daily targets updated successfully!',
          snackPosition: SnackPosition.TOP,
        );
      },
      failure: (failure) {
        Get.snackbar('Error', failure.message);
      },
    );
  }
}
