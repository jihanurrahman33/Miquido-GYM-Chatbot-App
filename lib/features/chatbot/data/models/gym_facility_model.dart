import '../../domain/entities/gym_facility_entity.dart';

class GymFacilityModel extends GymFacilityEntity {
  const GymFacilityModel({
    required super.id,
    required super.name,
    required super.address,
    required super.distanceMeters,
    required super.openingHours,
    required super.rating,
    required super.priceInfo,
    required super.amenities,
    super.description,
  });

  factory GymFacilityModel.fromJson(Map<String, dynamic> json) {
    return GymFacilityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distanceMeters: (json['distanceMeters'] as num).toInt(),
      openingHours: json['openingHours'] as String,
      rating: (json['rating'] as num).toDouble(),
      priceInfo: json['priceInfo'] as String,
      amenities: (json['amenities'] as List<dynamic>).map((e) => e.toString()).toList(),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distanceMeters': distanceMeters,
      'openingHours': openingHours,
      'rating': rating,
      'priceInfo': priceInfo,
      'amenities': amenities,
      'description': description,
    };
  }

  factory GymFacilityModel.fromEntity(GymFacilityEntity entity) {
    return GymFacilityModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      distanceMeters: entity.distanceMeters,
      openingHours: entity.openingHours,
      rating: entity.rating,
      priceInfo: entity.priceInfo,
      amenities: entity.amenities,
      description: entity.description,
    );
  }
}
