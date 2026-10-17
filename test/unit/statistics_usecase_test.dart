import 'package:flutter_test/flutter_test.dart';
import 'package:miquido/core/storage/storage_service.dart';
import 'package:miquido/features/statistics/data/datasources/statistics_local_datasource.dart';
import 'package:miquido/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:miquido/features/statistics/domain/usecases/get_user_metrics_usecase.dart';

class MockStorageService implements IStorageService {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> init() async {}

  @override
  T? read<T>(String key) => _data[key] as T?;

  @override
  Future<void> write(String key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }
}

void main() {
  group('Statistics UseCase tests', () {
    late MockStorageService mockStorage;
    late StatisticsLocalDataSource dataSource;
    late StatisticsRepositoryImpl repository;
    late GetUserMetricsUseCase useCase;

    setUp(() {
      mockStorage = MockStorageService();
      dataSource = StatisticsLocalDataSource(mockStorage);
      repository = StatisticsRepositoryImpl(dataSource);
      useCase = GetUserMetricsUseCase(repository);
    });

    test('Fetches statistics and verifies ring progress calculations', () async {
      final result = await useCase.execute();

      expect(result.metrics.calBurnt, equals('3.950'));
      expect(result.metrics.totalTime, equals('3h 14min'));
      expect(result.metrics.exercises, equals(15));
      expect(result.metrics.breaks, equals(5));

      // Progress checks
      expect(result.metrics.sleepProgress, closeTo(6.083 / 8.0, 0.01));
      expect(result.metrics.caloriesProgress, closeTo(1050 / 2000, 0.01));
      expect(result.metrics.stepsProgress, closeTo(2015 / 6000, 0.01));

      // Weekdays
      expect(result.weekDays.length, equals(7));
      expect(result.weekDays[2].dayNumber, equals(15));
      expect(result.weekDays[2].isSelected, isTrue);
    });
  });
}
