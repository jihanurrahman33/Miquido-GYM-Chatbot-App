import 'gym_facility_entity.dart';

enum MessageSender { bot, user }

class ChatMessageEntity {
  final String id;
  final MessageSender sender;
  final String text;
  final DateTime timestamp;
  final List<String> quickReplies;
  final GymFacilityEntity? facilityRecommendation;

  const ChatMessageEntity({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.quickReplies = const [],
    this.facilityRecommendation,
  });

  bool get isFromBot => sender == MessageSender.bot;
  bool get hasFacility => facilityRecommendation != null;
  bool get hasQuickReplies => quickReplies.isNotEmpty;
}
