import '../../../../core/storage/storage_service.dart';
import '../models/chat_message_model.dart';
import '../models/gym_booking_model.dart';
import '../models/gym_facility_model.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class IChatbotLocalDataSource {
  Future<List<ChatMessageModel>> getMessages();
  Future<void> saveMessages(List<ChatMessageModel> messages);
  Future<List<GymFacilityModel>> getFacilities();
  Future<List<GymBookingModel>> getBookings();
  Future<GymBookingModel> createBooking(GymBookingModel booking);
  Future<bool> cancelBooking(String bookingId);
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
    GymFacilityModel(
      id: 'g4',
      name: 'PowerStudio Crossfit',
      address: 'Grzegórzecka 18',
      distanceMeters: 800,
      openingHours: '07:00 AM – 10:00 PM',
      rating: 4.8,
      priceInfo: '40 zł/drop-in class',
      amenities: ['Gym', 'CrossFit', 'Showers'],
      description: 'High intensity strength and conditioning facility with Olympic lifting platforms.',
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
  Future<List<GymBookingModel>> getBookings() async {
    final raw = _storageService.read<List<dynamic>>('user_bookings');
    if (raw != null && raw.isNotEmpty) {
      return raw.map((e) => GymBookingModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    // Default initial confirmed booking
    final initialBookings = [
      GymBookingModel(
        id: 'book_initial_1',
        facilityId: 'g3',
        facilityName: 'BodyWorks',
        facilityAddress: 'Nadwiślańska 12 street',
        slotTime: 'Today at 04:00 PM',
        date: DateTime.now(),
        price: '30 zł',
        status: 'confirmed',
        qrCodeData: 'MIQUIDO-BW-PASS-99214',
      ),
    ];

    await _storageService.write('user_bookings', initialBookings.map((e) => e.toJson()).toList());
    return initialBookings;
  }

  @override
  Future<GymBookingModel> createBooking(GymBookingModel booking) async {
    final current = await getBookings();
    final updated = List<GymBookingModel>.from(current)..insert(0, booking);
    await _storageService.write('user_bookings', updated.map((e) => e.toJson()).toList());
    return booking;
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    final current = await getBookings();
    final updated = current.map((b) {
      if (b.id == bookingId) {
        return GymBookingModel(
          id: b.id,
          facilityId: b.facilityId,
          facilityName: b.facilityName,
          facilityAddress: b.facilityAddress,
          slotTime: b.slotTime,
          date: b.date,
          price: b.price,
          status: 'cancelled',
          qrCodeData: b.qrCodeData,
        );
      }
      return b;
    }).toList();

    await _storageService.write('user_bookings', updated.map((e) => e.toJson()).toList());
    return true;
  }

  @override
  Future<void> clearHistory() async {
    await _storageService.remove('chatbot_history');
  }
}
