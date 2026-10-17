import 'package:flutter_test/flutter_test.dart';
import 'package:miquido/core/storage/storage_service.dart';
import 'package:miquido/features/chatbot/data/datasources/chatbot_local_datasource.dart';
import 'package:miquido/features/chatbot/data/repositories/chatbot_repository_impl.dart';

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
  group('ChatbotRepository & LocalDataSource tests', () {
    late MockStorageService mockStorage;
    late ChatbotLocalDataSource localDataSource;
    late ChatbotRepositoryImpl repository;

    setUp(() {
      mockStorage = MockStorageService();
      localDataSource = ChatbotLocalDataSource(mockStorage);
      repository = ChatbotRepositoryImpl(localDataSource);
    });

    test('Loads initial conversation history matching Figma mock', () async {
      final history = await repository.getChatHistory();
      expect(history.length, 3);
      expect(history[0].text, contains("Hello, I'm FitBot!"));
      expect(history[1].text, equals('Show me other options'));
      expect(history[2].hasFacility, isTrue);
      expect(history[2].facilityRecommendation!.name, contains('BodyWorks'));
    });

    test('Sends user message and generates contextual FitBot recommendation', () async {
      final reply = await repository.sendMessage('Can you book me a visit in a gym?');
      expect(reply.isFromBot, isTrue);
      expect(reply.hasFacility, isTrue);
      expect(reply.facilityRecommendation!.name, contains('BodyWorks'));

      final fullHistory = await repository.getChatHistory();
      // Should now have initial 3 + user msg + bot reply = 5 messages
      expect(fullHistory.length, 5);
    });

    test('Successfully books facility and persists to storage', () async {
      final booked = await repository.bookFacility('g3', DateTime.now());
      expect(booked, isTrue);

      final bookings = mockStorage.read<List<dynamic>>('user_bookings');
      expect(bookings, isNotNull);
      expect(bookings!.length, 1);
      expect(bookings[0]['facilityId'], equals('g3'));
    });
  });
}
