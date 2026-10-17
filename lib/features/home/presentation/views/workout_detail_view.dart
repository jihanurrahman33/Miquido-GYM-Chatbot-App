import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../domain/entities/workout_entity.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkoutEntity workout = Get.arguments as WorkoutEntity;

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
        title: Text(
          workout.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(workout.bgColorHex),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        workout.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Text(
                        workout.timeString,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppTheme.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        workout.location,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.bodyText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Planned Exercises',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 16),

            _buildExerciseItem('1', 'Treadmill Warmup Interval', '10 min • 4.5 km/h'),
            _buildExerciseItem('2', 'Dumbbell Incline Bench Press', '4 sets • 12 reps'),
            _buildExerciseItem('3', 'Barbell Back Squats', '4 sets • 10 reps'),
            _buildExerciseItem('4', 'Cable Lat Pulldowns', '3 sets • 12 reps'),
            _buildExerciseItem('5', 'Core Planks & Leg Raises', '3 rounds • 60 sec'),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  AppSnackbar.success(
                    'Workout Completed! 👏',
                    '350 kcal logged to your daily activity.',
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navBarDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Mark Workout Completed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String number, String title, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightBlueBg,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_outline_rounded, color: AppTheme.mutedText, size: 20),
        ],
      ),
    );
  }
}
