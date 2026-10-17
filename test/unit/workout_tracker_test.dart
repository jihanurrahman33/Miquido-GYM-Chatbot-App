import 'package:flutter_test/flutter_test.dart';
import 'package:miquido/features/home/presentation/controllers/workout_tracker_controller.dart';

void main() {
  group('WorkoutTrackerController tests', () {
    late WorkoutTrackerController controller;

    setUp(() {
      controller = WorkoutTrackerController();
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
    });

    test('Initializes with first exercise and correct default duration', () {
      expect(controller.currentExerciseIndex.value, 0);
      expect(controller.secondsRemaining.value, 45);
      expect(controller.isRunning.value, isFalse);
      expect(controller.isCompleted.value, isFalse);
    });

    test('Toggles timer state correctly', () {
      controller.toggleTimer();
      expect(controller.isRunning.value, isTrue);

      controller.toggleTimer();
      expect(controller.isRunning.value, isFalse);
    });

    test('Advances to next exercise when nextExercise is called', () {
      controller.nextExercise();
      expect(controller.currentExerciseIndex.value, 1);
      expect(controller.secondsRemaining.value, 45);
      expect(controller.isRunning.value, isTrue);
    });

    test('Marks as completed on the last exercise', () {
      final total = controller.exercises.length;
      for (int i = 0; i < total - 1; i++) {
        controller.nextExercise();
      }
      expect(controller.currentExerciseIndex.value, total - 1);
      expect(controller.isCompleted.value, isFalse);

      controller.nextExercise();
      expect(controller.isCompleted.value, isTrue);
    });
  });
}
