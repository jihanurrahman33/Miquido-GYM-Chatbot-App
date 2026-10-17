import '../entities/chat_message_entity.dart';
import '../entities/gym_facility_entity.dart';

abstract class IChatbotRepository {
  Future<List<ChatMessageEntity>> getChatHistory();
  Future<ChatMessageEntity> sendMessage(String text);
  Future<bool> bookFacility(String facilityId, DateTime preferredTime);
  Future<List<GymFacilityEntity>> getRecommendedFacilities();
  Future<void> clearHistory();
}
