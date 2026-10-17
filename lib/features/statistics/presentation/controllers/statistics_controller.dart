import 'package:get/get.dart';
import '../../domain/entities/user_metric_entity.dart';
import '../../domain/usecases/get_user_metrics_usecase.dart';

class StatisticsController extends GetxController {
  final GetUserMetricsUseCase _getUserMetricsUseCase;

  StatisticsController(this._getUserMetricsUseCase);

  final RxBool isLoading = true.obs;
  final Rxn<UserMetricEntity> metrics = Rxn<UserMetricEntity>();
  final RxList<DayProgressEntity> weekDays = <DayProgressEntity>[].obs;
  final RxInt selectedDayIndex = 2.obs; // Wednesday index

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;
      final data = await _getUserMetricsUseCase.execute();
      metrics.value = data.metrics;
      weekDays.assignAll(data.weekDays);
    } catch (e) {
      // Handle error gracefully
    } finally {
      isLoading.value = false;
    }
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }
}
