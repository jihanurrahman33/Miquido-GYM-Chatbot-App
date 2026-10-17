import '../../../../core/utils/result.dart';
import '../entities/chat_message_entity.dart';
import '../entities/gym_booking_entity.dart';
import '../repositories/i_chatbot_repository.dart';

class GetChatHistoryUseCase {
  final IChatbotRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<Result<List<ChatMessageEntity>>> execute() {
    return _repository.getChatHistory();
  }
}

class SendChatMessageUseCase {
  final IChatbotRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<Result<ChatMessageEntity>> execute(String text) {
    return _repository.sendMessage(text);
  }
}

class BookGymFacilityUseCase {
  final IChatbotRepository _repository;

  BookGymFacilityUseCase(this._repository);

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
