import '../../../../core/storage/storage_service.dart';
import '../models/workout_model.dart';
import '../models/activity_point_model.dart';
import '../../../chatbot/data/models/gym_facility_model.dart';

abstract class IHomeLocalDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<List<GymFacilityModel>> getNearbyGyms();
  Future<List<ActivityPointModel>> getWeeklyActivities([String period = 'Weekly']);
}

class HomeLocalDataSource implements IHomeLocalDataSource {
  final IStorageService _storageService;

  HomeLocalDataSource(this._storageService);

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    final raw = _storageService.read<List<dynamic>>('home_workouts');
    if (raw != null && raw.isNotEmpty) {
      return raw.map((e) => WorkoutModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    // Default mock data directly reflecting Figma 403:3051
    final defaults = [
      const WorkoutModel(
        id: 'w1',
        title: 'Workout',
        timeString: 'Today at 2:45 PM',
        category: 'FITNESS',
        location: 'Aleja Pokoju',
        bgColorHex: 0xFFEFF3FE,
      ),
      const WorkoutModel(
        id: 'w2',
        title: 'Pull Up & Cardio',
        timeString: 'Tonight at 7:00 PM',
        category: 'STRENGTH',
        location: 'Dietla 45',
        bgColorHex: 0xFFFFF6ED,
      ),
      const WorkoutModel(
        id: 'w3',
        title: 'Morning Yoga Flow',
        timeString: 'Tomorrow at 8:00 AM',
        category: 'YOGA',
        location: 'Floriańska 10',
        bgColorHex: 0xFFF1F8EE,
      ),
    ];

    await _storageService.write(
      'home_workouts',
      defaults.map((e) => e.toJson()).toList(),
    );
    return defaults;
  }

  @override
  Future<List<GymFacilityModel>> getNearbyGyms() async {
    final raw = _storageService.read<List<dynamic>>('nearby_gyms');
    if (raw != null && raw.isNotEmpty) {
      return raw.map((e) => GymFacilityModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }

    // Default gyms from Figma 403:3051 and 403:2913
    final defaults = [
      const GymFacilityModel(
        id: 'g1',
        name: 'GymFit',
        address: 'Starowiślna 12',
        distanceMeters: 250,
        openingHours: '10:00 AM – 11:00 PM',
        rating: 5.0,
        priceInfo: '25 zł/entrance',
        amenities: ['Gym', 'Showers', 'CrossFit'],
        description: 'Modern gym facility with premium equipment and professional personal trainers.',
      ),
      const GymFacilityModel(
        id: 'g2',
        name: 'Lotus',
        address: 'Starowiślna 24',
        distanceMeters: 630,
        openingHours: '24/7',
        rating: 5.0,
        priceInfo: '35 zł/entrance',
        amenities: ['Gym', 'SPA', 'Sauna'],
        description: '24/7 wellness center with relaxing spa area and advanced cardio machines.',
      ),
      const GymFacilityModel(
        id: 'g3',
        name: 'BodyWorks',
        address: 'Nadwiślańska 12 street',
        distanceMeters: 250,
        openingHours: '06:00 AM – 11:00 PM',
        rating: 4.9,
        priceInfo: '30 zł/one entrance all day',
        amenities: ['Gym', 'SPA', 'Pool'],
        description: 'Comprehensive sports club featuring swimming pool, complete spa and heavy weights.',
      ),
    ];

    await _storageService.write(
      'nearby_gyms',
      defaults.map((e) => e.toJson()).toList(),
    );
    return defaults;
  }

  @override
  Future<List<ActivityPointModel>> getWeeklyActivities([String period = 'Weekly']) async {
    if (period == 'Monthly') {
      return const [
        ActivityPointModel(dayShort: 'W1', durationHours: 2.2, tooltipText: '2h 12min'),
        ActivityPointModel(dayShort: 'W2', durationHours: 3.5, tooltipText: '3h 30min'),
        ActivityPointModel(dayShort: 'W3', durationHours: 4.1, tooltipText: '4h 06min', isPeak: true),
        ActivityPointModel(dayShort: 'W4', durationHours: 2.8, tooltipText: '2h 48min'),
      ];
    } else if (period == 'Yearly') {
      return const [
        ActivityPointModel(dayShort: 'Q1', durationHours: 2.9, tooltipText: '2h 54min'),
        ActivityPointModel(dayShort: 'Q2', durationHours: 3.8, tooltipText: '3h 48min', isPeak: true),
        ActivityPointModel(dayShort: 'Q3', durationHours: 3.1, tooltipText: '3h 06min'),
        ActivityPointModel(dayShort: 'Q4', durationHours: 2.4, tooltipText: '2h 24min'),
      ];
    }

    // Default Weekly data matching Figma 403:3051 & 403:2897
    return const [
      ActivityPointModel(dayShort: 'Mon', durationHours: 1.8, tooltipText: '1h 50min'),
      ActivityPointModel(dayShort: 'Tue', durationHours: 2.7, tooltipText: '2h 45min'),
      ActivityPointModel(
        dayShort: 'Wed',
        durationHours: 3.23,
        tooltipText: '3h 14min',
        isPeak: true,
      ),
      ActivityPointModel(dayShort: 'Thu', durationHours: 2.1, tooltipText: '2h 10min'),
      ActivityPointModel(dayShort: 'Fri', durationHours: 3.6, tooltipText: '3h 35min'),
      ActivityPointModel(dayShort: 'Sat', durationHours: 2.5, tooltipText: '2h 30min'),
      ActivityPointModel(dayShort: 'Sun', durationHours: 4.2, tooltipText: '4h 15min'),
    ];
  }
}
