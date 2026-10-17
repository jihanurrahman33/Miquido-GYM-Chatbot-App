import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../statistics/presentation/controllers/statistics_controller.dart';

class ProfileController extends GetxController {
  final IStorageService _storageService;

  ProfileController(this._storageService);

  final RxDouble sleepGoal = 8.0.obs;
  final RxInt caloriesGoal = 2000.obs;
  final RxInt stepsGoal = 6000.obs;

  @override
  void onInit() {
    super.onInit();
    final statsController = Get.isRegistered<StatisticsController>() ? Get.find<StatisticsController>() : null;
    if (statsController?.metrics.value != null) {
      sleepGoal.value = statsController!.metrics.value!.sleepTargetHours;
      caloriesGoal.value = statsController.metrics.value!.caloriesTarget;
      stepsGoal.value = statsController.metrics.value!.stepsTarget;
    }
  }

  void openEditGoalsSheet(BuildContext context) {
    final tempSleep = sleepGoal.value.obs;
    final tempCalories = caloriesGoal.value.obs;
    final tempSteps = stepsGoal.value.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Health Targets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sleep Goal
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sleep Goal', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${tempSleep.value.toInt()} hours', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryBlue)),
                    ],
                  ),
                  Slider(
                    value: tempSleep.value,
                    min: 5.0,
                    max: 12.0,
                    divisions: 7,
                    activeColor: AppTheme.ringSleep,
                    onChanged: (v) => tempSleep.value = v,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Calories Goal
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Active Calories Goal', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${tempCalories.value} kcal', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ringCalories)),
                    ],
                  ),
                  Slider(
                    value: tempCalories.value.toDouble(),
                    min: 1000,
                    max: 4000,
                    divisions: 30,
                    activeColor: AppTheme.ringCalories,
                    onChanged: (v) => tempCalories.value = v.toInt(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Steps Goal
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daily Steps Goal', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${tempSteps.value} steps', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ringSteps)),
                    ],
                  ),
                  Slider(
                    value: tempSteps.value.toDouble(),
                    min: 2000,
                    max: 20000,
                    divisions: 18,
                    activeColor: AppTheme.ringSteps,
                    onChanged: (v) => tempSteps.value = v.toInt(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  sleepGoal.value = tempSleep.value;
                  caloriesGoal.value = tempCalories.value;
                  stepsGoal.value = tempSteps.value;

                  final statsController = Get.isRegistered<StatisticsController>() ? Get.find<StatisticsController>() : null;
                  statsController?.updateHealthGoals(
                    sleepTargetHours: tempSleep.value,
                    caloriesTarget: tempCalories.value,
                    stepsTarget: tempSteps.value,
                  );

                  Get.back();
                  AppSnackbar.success('Targets Updated', 'Your daily health targets have been synced across all statistics.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Targets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> clearCache() async {
    await _storageService.clear();
    AppSnackbar.info(
      'Cache Reset',
      'Local storage data has been restored to defaults.',
    );
  }
}
