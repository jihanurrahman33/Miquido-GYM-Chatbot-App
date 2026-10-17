class GymFacilityEntity {
  final String id;
  final String name;
  final String address;
  final int distanceMeters;
  final String openingHours;
  final double rating;
  final String priceInfo;
  final List<String> amenities;
  final String description;

  const GymFacilityEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceMeters,
    required this.openingHours,
    required this.rating,
    required this.priceInfo,
    required this.amenities,
    this.description = '',
  });

  String get formattedDistance => '$distanceMeters meters';
}
