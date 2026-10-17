import 'package:flutter_test/flutter_test.dart';
import 'package:miquido/core/storage/storage_service.dart';
import 'package:miquido/features/chatbot/data/datasources/chatbot_local_datasource.dart';
import 'package:miquido/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:miquido/features/chatbot/domain/usecases/booking_usecases.dart';

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
  group('Booking Use Cases & Domain Logic', () {
    late MockStorageService mockStorage;
    late ChatbotLocalDataSource dataSource;
    late ChatbotRepositoryImpl repository;
    late GetUserBookingsUseCase getUserBookingsUseCase;
    late CreateGymBookingUseCase createGymBookingUseCase;
    late CancelBookingUseCase cancelBookingUseCase;

    setUp(() {
      mockStorage = MockStorageService();
      dataSource = ChatbotLocalDataSource(mockStorage);
      repository = ChatbotRepositoryImpl(dataSource);
      getUserBookingsUseCase = GetUserBookingsUseCase(repository);
      createGymBookingUseCase = CreateGymBookingUseCase(repository);
      cancelBookingUseCase = CancelBookingUseCase(repository);
    });

    test('GetUserBookingsUseCase returns active and seed bookings', () async {
      final result = await getUserBookingsUseCase.execute();
      expect(result.isSuccess, isTrue);
      expect(result.data.length, greaterThanOrEqualTo(1));
      expect(result.data.first.isConfirmed, isTrue);
    });

    test('CreateGymBookingUseCase creates a new valid booking pass', () async {
      final createResult = await createGymBookingUseCase.execute(
        facilityId: 'g1',
        facilityName: 'GymFit Center',
        facilityAddress: 'Starowiślna 12',
        slotTime: 'Today at 06:00 PM',
        price: '25 zł/entrance',
      );

      expect(createResult.isSuccess, isTrue);
      final booking = createResult.data;
      expect(booking.facilityName, equals('GymFit Center'));
      expect(booking.isConfirmed, isTrue);
      expect(booking.qrCodeData, contains('MIQ-'));

      // Verify list has updated
      final listResult = await getUserBookingsUseCase.execute();
      expect(listResult.isSuccess, isTrue);
      expect(listResult.data.any((b) => b.facilityName == 'GymFit Center'), isTrue);
    });

    test('CancelBookingUseCase successfully marks a booking as cancelled', () async {
      final createResult = await createGymBookingUseCase.execute(
        facilityId: 'g2',
        facilityName: 'Fitness Academy',
        facilityAddress: 'Krakowska 4',
        slotTime: 'Tomorrow at 10:00 AM',
        price: '28 zł',
      );

      final bookingId = createResult.data.id;
      final cancelResult = await cancelBookingUseCase.execute(bookingId);
      expect(cancelResult.isSuccess, isTrue);

      final listResult = await getUserBookingsUseCase.execute();
      final cancelled = listResult.data.firstWhere((b) => b.id == bookingId);
      expect(cancelled.isConfirmed, isFalse);
    });
  });
}
