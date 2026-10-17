import '../../../../core/utils/result.dart';
import '../entities/chat_message_entity.dart';
import '../entities/gym_booking_entity.dart';
import '../entities/gym_facility_entity.dart';

abstract class IChatbotRepository {
  Future<Result<List<ChatMessageEntity>>> getChatHistory();
  Future<Result<ChatMessageEntity>> sendMessage(String text);
  Future<Result<List<GymBookingEntity>>> getUserBookings();
  Future<Result<GymBookingEntity>> createBooking({
    required String facilityId,
    required String facilityName,
    required String facilityAddress,
    required String slotTime,
    required String price,
  });
  Future<Result<bool>> cancelBooking(String bookingId);
  Future<Result<List<GymFacilityEntity>>> getRecommendedFacilities();
  Future<Result<void>> clearHistory();
}
