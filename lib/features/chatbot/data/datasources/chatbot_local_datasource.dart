import '../../../../core/storage/storage_service.dart';
import '../models/chat_message_model.dart';
import '../models/gym_facility_model.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class IChatbotLocalDataSource {
  Future<List<ChatMessageModel>> getMessages();
  Future<void> saveMessages(List<ChatMessageModel> messages);
  Future<List<GymFacilityModel>> getFacilities();
  Future<bool> bookFacility(String facilityId, DateTime preferredTime);
  Future<void> clearHistory();
}

class ChatbotLocalDataSource implements IChatbotLocalDataSource {
  final IStorageService _storageService;

  ChatbotLocalDataSource(this._storageService);

  final List<GymFacilityModel> _allFacilities = const [
    GymFacilityModel(
      id: 'g3',
      name: 'BodyWorks on Nadwiślańska 12 street',
      address: 'Nadwiślańska 12 street, Kraków',
      distanceMeters: 250,
      openingHours: '06:00 AM – 11:00 PM',
      rating: 4.9,
      priceInfo: '30 zł/one entrance all day',
      amenities: ['Gym', 'SPA', 'Pool'],
      description: 'Comprehensive fitness club with Olympic size pool, modern weight room, sauna, and group wellness classes.',
    ),
    GymFacilityModel(
      id: 'g1',
      name: 'GymFit',
      address: 'Starowiślna 12',
      distanceMeters: 250,
      openingHours: '10:00 AM – 11:00 PM',
      rating: 5.0,
      priceInfo: '25 zł/entrance',
      amenities: ['Gym', 'Showers', 'CrossFit'],
      description: 'Top-rated strength training club in Old Town with certified coaches and functional training zones.',
    ),
    GymFacilityModel(
      id: 'g2',
      name: 'Lotus Wellness & Gym',
      address: 'Starowiślna 24',
      distanceMeters: 630,
      openingHours: '24/7',
      rating: 5.0,
      priceInfo: '35 zł/entrance',
      amenities: ['Gym', 'SPA', 'Sauna'],
      description: 'Relaxing boutique gym and thermal bath complex open round-the-clock.',
    ),
  ];

  @override
  Future<List<GymFacilityModel>> getFacilities() async {
    return _allFacilities;
  }

  @override
  Future<List<ChatMessageModel>> getMessages() async {
    final raw = _storageService.read<List<dynamic>>('chatbot_history');
    if (raw != null && raw.isNotEmpty) {
      return raw.map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    // Default conversation matching Figma 403:2913 precisely
    final baseTime = DateTime(2022, 6, 15, 8, 21); // Wed 8:21 AM

    final defaultMessages = [
      ChatMessageModel(
        id: 'msg_1',
        sender: MessageSender.bot,
        text: "Hello, I'm FitBot! 👋 I'm your personal sport assistant. How can I help you?",
        timestamp: baseTime,
        quickReplies: const [
          'Book me a visit in a gym',
          'Show me other sports facilities around',
        ],
      ),
      ChatMessageModel(
        id: 'msg_2',
        sender: MessageSender.user,
        text: 'Show me other options',
        timestamp: baseTime.add(const Duration(minutes: 1)),
      ),
      ChatMessageModel(
        id: 'msg_3',
        sender: MessageSender.bot,
        text: 'Ok, how about these?',
        timestamp: baseTime.add(const Duration(minutes: 2)),
        facilityRecommendation: _allFacilities.first,
        quickReplies: const [
          'Book BodyWorks visit',
          'Show opening hours',
          'Check workout tips',
        ],
      ),
    ];

    await saveMessages(defaultMessages);
    return defaultMessages;
  }

  @override
  Future<void> saveMessages(List<ChatMessageModel> messages) async {
    await _storageService.write(
      'chatbot_history',
      messages.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<bool> bookFacility(String facilityId, DateTime preferredTime) async {
    final existingBookings = _storageService.read<List<dynamic>>('user_bookings') ?? [];
    final newBooking = {
      'id': 'book_${DateTime.now().millisecondsSinceEpoch}',
      'facilityId': facilityId,
      'preferredTime': preferredTime.toIso8601String(),
      'status': 'confirmed',
      'createdAt': DateTime.now().toIso8601String(),
    };

    final updated = List<dynamic>.from(existingBookings)..add(newBooking);
    await _storageService.write('user_bookings', updated);
    return true;
  }

  @override
  Future<void> clearHistory() async {
    await _storageService.remove('chatbot_history');
  }
}
