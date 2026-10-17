import 'dart:async';
import 'package:get/get.dart';

class WorkoutTrackerController extends GetxController {
  final RxInt currentExerciseIndex = 0.obs;
  final RxInt secondsRemaining = 45.obs;
  final RxBool isRunning = false.obs;
  final RxBool isCompleted = false.obs;
  Timer? _timer;

  final List<Map<String, dynamic>> exercises = [
    {'name': 'Treadmill Warmup Interval', 'target': '10 min • 4.5 km/h', 'duration': 45},
    {'name': 'Dumbbell Incline Bench Press', 'target': '4 sets • 12 reps', 'duration': 45},
    {'name': 'Barbell Back Squats', 'target': '4 sets • 10 reps', 'duration': 50},
    {'name': 'Cable Lat Pulldowns', 'target': '3 sets • 12 reps', 'duration': 40},
    {'name': 'Core Planks & Leg Raises', 'target': '3 rounds • 60 sec', 'duration': 60},
  ];

  @override
  void onInit() {
    super.onInit();
    _resetTimerForCurrent();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _resetTimerForCurrent() {
    secondsRemaining.value = exercises[currentExerciseIndex.value]['duration'] as int;
  }

  void toggleTimer() {
    if (isRunning.value) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        nextExercise();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunning.value = false;
  }

  void nextExercise() {
    _timer?.cancel();
    isRunning.value = false;

    if (currentExerciseIndex.value < exercises.length - 1) {
      currentExerciseIndex.value++;
      _resetTimerForCurrent();
      startTimer();
    } else {
      isCompleted.value = true;
    }
  }

  void restartSession() {
    _timer?.cancel();
    currentExerciseIndex.value = 0;
    isCompleted.value = false;
    _resetTimerForCurrent();
  }
}
