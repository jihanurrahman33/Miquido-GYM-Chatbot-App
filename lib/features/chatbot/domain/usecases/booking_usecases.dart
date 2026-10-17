import '../../../../core/utils/result.dart';
import '../entities/gym_booking_entity.dart';
import '../repositories/i_chatbot_repository.dart';

class GetUserBookingsUseCase {
  final IChatbotRepository _repository;

  GetUserBookingsUseCase(this._repository);

  Future<Result<List<GymBookingEntity>>> execute() {
    return _repository.getUserBookings();
  }
}

class CancelBookingUseCase {
  final IChatbotRepository _repository;

  CancelBookingUseCase(this._repository);

  Future<Result<bool>> execute(String bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}

class CreateGymBookingUseCase {
  final IChatbotRepository _repository;

  CreateGymBookingUseCase(this._repository);

  Future<Result<GymBookingEntity>> execute({
    required String facilityId,
    required String facilityName,
    required String facilityAddress,
    required String slotTime,
    required String price,
  }) {
    return _repository.createBooking(
      facilityId: facilityId,
      facilityName: facilityName,
      facilityAddress: facilityAddress,
      slotTime: slotTime,
      price: price,
    );
  }
}
