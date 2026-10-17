import '../../domain/entities/chat_message_entity.dart';
import 'gym_facility_model.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.sender,
    required super.text,
    required super.timestamp,
    super.quickReplies,
    super.facilityRecommendation,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      quickReplies: (json['quickReplies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      facilityRecommendation: json['facilityRecommendation'] != null
          ? GymFacilityModel.fromJson(
              json['facilityRecommendation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender == MessageSender.user ? 'user' : 'bot',
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'quickReplies': quickReplies,
      'facilityRecommendation': facilityRecommendation != null
          ? GymFacilityModel.fromEntity(facilityRecommendation!).toJson()
          : null,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      sender: entity.sender,
      text: entity.text,
      timestamp: entity.timestamp,
      quickReplies: entity.quickReplies,
      facilityRecommendation: entity.facilityRecommendation,
    );
  }
}
