import 'dart:math';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/gym_booking_entity.dart';
import '../../domain/entities/gym_facility_entity.dart';
import '../../domain/repositories/i_chatbot_repository.dart';
import '../datasources/chatbot_local_datasource.dart';
import '../models/chat_message_model.dart';
import '../models/gym_booking_model.dart';

class ChatbotRepositoryImpl implements IChatbotRepository {
  final IChatbotLocalDataSource _localDataSource;

  ChatbotRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<ChatMessageEntity>>> getChatHistory() async {
    try {
      final messages = await _localDataSource.getMessages();
      return Result.success(messages);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load chat history: $e'));
    }
  }

  @override
  Future<Result<List<GymFacilityEntity>>> getRecommendedFacilities() async {
    try {
      final facilities = await _localDataSource.getFacilities();
      return Result.success(facilities);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load facilities: $e'));
    }
  }

  @override
  Future<Result<List<GymBookingEntity>>> getUserBookings() async {
    try {
      final bookings = await _localDataSource.getBookings();
      return Result.success(bookings);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to load bookings: $e'));
    }
  }

  @override
  Future<Result<GymBookingEntity>> createBooking({
    required String facilityId,
    required String facilityName,
    required String facilityAddress,
    required String slotTime,
    required String price,
  }) async {
    try {
      final bookingModel = GymBookingModel(
        id: 'book_${DateTime.now().millisecondsSinceEpoch}',
        facilityId: facilityId,
        facilityName: facilityName,
        facilityAddress: facilityAddress,
        slotTime: slotTime,
        date: DateTime.now(),
        price: price,
        status: 'confirmed',
        qrCodeData: 'MIQ-${facilityName.toUpperCase().replaceAll(' ', '')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      );

      final created = await _localDataSource.createBooking(bookingModel);
      return Result.success(created);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to create booking: $e'));
    }
  }

  @override
  Future<Result<bool>> cancelBooking(String bookingId) async {
    try {
      final success = await _localDataSource.cancelBooking(bookingId);
      return Result.success(success);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to cancel booking: $e'));
    }
  }

  @override
  Future<Result<void>> clearHistory() async {
    try {
      await _localDataSource.clearHistory();
      return Result.success(null);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to clear history: $e'));
    }
  }

  @override
  Future<Result<ChatMessageEntity>> sendMessage(String text) async {
    try {
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
        await createBooking(
          facilityId: 'g3',
          facilityName: 'BodyWorks',
          facilityAddress: 'Nadwiślańska 12 street',
          slotTime: 'Today at 04:00 PM',
          price: '30 zł',
        );
        botReply = '🎉 Your booking at BodyWorks is confirmed! You can show this pass at the reception counter. Have a great workout!';
        nextQuickReplies = [
          'View my active pass',
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
          'Start workout tracker',
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

      return Result.success(botMsg);
    } catch (e) {
      return Result.failure(StorageFailure('Failed to send message: $e'));
    }
  }
}
