import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/workout_tracker_controller.dart';

class WorkoutTrackerView extends GetView<WorkoutTrackerController> {
  const WorkoutTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppTheme.darkText, size: 20),
          ),
        ),
        title: const Text(
          'Workout Session',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.darkText),
        ),
      ),
      body: Obx(() {
        if (controller.isCompleted.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Lottie.asset(
                      'assets/animations/celebration.json',
                      repeat: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Workout Completed! 🎉',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.darkText),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You crushed today\'s training routine. 350 kcal burnt and added to your activity record!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Return to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
        }

        final currentEx = controller.exercises[controller.currentExerciseIndex.value];
        final totalSec = currentEx['duration'] as int;
        final currentSec = controller.secondsRemaining.value;
        final progress = (1.0 - (currentSec / totalSec)).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Exercise ${controller.currentExerciseIndex.value + 1} of ${controller.exercises.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 10),
              Text(
                currentEx['name'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.darkText),
              ),
              const SizedBox(height: 6),
              Text(
                currentEx['target'] as String,
                style: const TextStyle(fontSize: 14, color: AppTheme.mutedText),
              ),

              const Spacer(),

              // Circular Countdown Timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: AppTheme.lightBlueBg,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '00:${currentSec.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.isRunning.value ? 'INTERVAL ACTIVE' : 'PAUSED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: controller.isRunning.value ? AppTheme.successGreen : AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play / Pause
                  ElevatedButton(
                    onPressed: controller.toggleTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isRunning.value ? AppTheme.navBarDark : AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(22),
                    ),
                    child: Icon(
                      controller.isRunning.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Next Exercise
                  IconButton(
                    onPressed: controller.nextExercise,
                    icon: const Icon(Icons.skip_next_rounded, size: 36, color: AppTheme.darkText),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}
