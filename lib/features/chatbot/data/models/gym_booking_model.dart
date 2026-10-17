import '../../domain/entities/gym_booking_entity.dart';

class GymBookingModel extends GymBookingEntity {
  const GymBookingModel({
    required super.id,
    required super.facilityId,
    required super.facilityName,
    required super.facilityAddress,
    required super.slotTime,
    required super.date,
    required super.price,
    required super.status,
    required super.qrCodeData,
  });

  factory GymBookingModel.fromJson(Map<String, dynamic> json) {
    return GymBookingModel(
      id: json['id'] as String,
      facilityId: json['facilityId'] as String,
      facilityName: json['facilityName'] as String,
      facilityAddress: json['facilityAddress'] as String,
      slotTime: json['slotTime'] as String,
      date: DateTime.parse(json['date'] as String),
      price: json['price'] as String,
      status: json['status'] as String,
      qrCodeData: json['qrCodeData'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facilityId': facilityId,
      'facilityName': facilityName,
      'facilityAddress': facilityAddress,
      'slotTime': slotTime,
      'date': date.toIso8601String(),
      'price': price,
      'status': status,
      'qrCodeData': qrCodeData,
    };
  }

  factory GymBookingModel.fromEntity(GymBookingEntity entity) {
    return GymBookingModel(
      id: entity.id,
      facilityId: entity.facilityId,
      facilityName: entity.facilityName,
      facilityAddress: entity.facilityAddress,
      slotTime: entity.slotTime,
      date: entity.date,
      price: entity.price,
      status: entity.status,
      qrCodeData: entity.qrCodeData,
    );
  }
}
