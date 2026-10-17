class GymBookingEntity {
  final String id;
  final String facilityId;
  final String facilityName;
  final String facilityAddress;
  final String slotTime;
  final DateTime date;
  final String price;
  final String status;
  final String qrCodeData;

  const GymBookingEntity({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.facilityAddress,
    required this.slotTime,
    required this.date,
    required this.price,
    required this.status,
    required this.qrCodeData,
  });

  bool get isConfirmed => status == 'confirmed';
}
