import 'dart:math';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/gym_facility_entity.dart';
import '../../domain/repositories/i_chatbot_repository.dart';
import '../datasources/chatbot_local_datasource.dart';
import '../models/chat_message_model.dart';

class ChatbotRepositoryImpl implements IChatbotRepository {
  final IChatbotLocalDataSource _localDataSource;

  ChatbotRepositoryImpl(this._localDataSource);

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    return _localDataSource.getMessages();
  }

  @override
  Future<List<GymFacilityEntity>> getRecommendedFacilities() async {
    return _localDataSource.getFacilities();
  }

  @override
  Future<bool> bookFacility(String facilityId, DateTime preferredTime) async {
    return _localDataSource.bookFacility(facilityId, preferredTime);
  }

  @override
  Future<void> clearHistory() async {
    return _localDataSource.clearHistory();
  }

  @override
  Future<ChatMessageEntity> sendMessage(String text) async {
    final currentHistory = await _localDataSource.getMessages();

    // 1. Save user's message
    final userMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_user',
      sender: MessageSender.user,
      text: text,
      timestamp: DateTime.now(),
    );
    final updatedHistory = List<ChatMessageModel>.from(currentHistory)..add(userMsg);

    // 2. Formulate dynamic FitBot answer
    final lower = text.toLowerCase();
    final facilities = await _localDataSource.getFacilities();

    String botReply;
    GymFacilityEntity? facilityRecommendation;
    List<String> nextQuickReplies = [];

    if (lower.contains('book') || lower.contains('visit') || lower.contains('reserve')) {
      final targetGym = facilities.first;
      botReply = 'I found the top-rated sports club right near you! Would you like to confirm a pass for today?';
      facilityRecommendation = targetGym;
      nextQuickReplies = [
        'Confirm booking at BodyWorks',
        'Show GymFit instead',
        'Check my calendar',
      ];
    } else if (lower.contains('confirm booking') || lower.contains('booked')) {
      await _localDataSource.bookFacility('g3', DateTime.now().add(const Duration(hours: 2)));
      botReply = '🎉 Your booking at BodyWorks is confirmed! You can show this pass at the reception counter. Have a great workout!';
      nextQuickReplies = [
        'Add to calendar',
        'Show directions',
        'Suggest workout routine',
      ];
    } else if (lower.contains('facility') || lower.contains('facilities') || lower.contains('gym') || lower.contains('option')) {
      final rand = facilities[Random().nextInt(facilities.length)];
      botReply = 'Here is another great facility in your area with full equipment:';
      facilityRecommendation = rand;
      nextQuickReplies = [
        'Book me a visit here',
        'Show opening hours',
        'Suggest cardio exercises',
      ];
    } else if (lower.contains('routine') || lower.contains('workout') || lower.contains('exercise')) {
      botReply = 'For today, I recommend a 45-minute Upper Body & Core session:\n• 10 min warm-up jog\n• 3x12 Dumbbell bench press\n• 3x10 Pull-ups / Lat pulldown\n• 15 min HIIT finisher!';
      nextQuickReplies = [
        'Log this workout',
        'Show nearby gyms',
        'Check calories burnt',
      ];
    } else if (lower.contains('calorie') || lower.contains('step') || lower.contains('progress') || lower.contains('stat')) {
      botReply = 'You have burnt 3,950 kcal this week and completed 3h 14min of training. You are on track for your goal! 🚀';
      nextQuickReplies = [
        'View full statistics',
        'Book recovery sauna session',
        'Show upcoming workouts',
      ];
    } else {
      botReply = 'Got it! I am ready to help you optimize your training, schedule gym passes, or track your performance. What would you like to do next?';
      nextQuickReplies = [
        'Book me a visit in a gym',
        'Show me sports facilities around',
        'Suggest workout routine',
      ];
    }

    final botMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_bot',
      sender: MessageSender.bot,
      text: botReply,
      timestamp: DateTime.now().add(const Duration(milliseconds: 300)),
      facilityRecommendation: facilityRecommendation,
      quickReplies: nextQuickReplies,
    );

    updatedHistory.add(botMsg);
    await _localDataSource.saveMessages(updatedHistory);

    return botMsg;
  }
}
